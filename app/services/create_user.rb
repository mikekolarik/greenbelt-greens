require 'net/http'
require 'uri'

class CreateUser
  include Concerns::Service
  attr_accessor :success, :user, :stripe_message, :ref_code

  def call(user_params: {}, card_params: {}, referral_code: '')
    @success = false
    @user = User.new
    User.connection.transaction do
      begin
        if _check_for_params_valid?(params: user_params)
          @user.update_attributes!(user_params)
          if _send_request_to_stripe!(user: @user, card_params: card_params) &&
             _create_user_ingredients_reference!(user: @user, ingredient_ids: user_params[:ingredient_ids])
            unless referral_code.blank?
              update_account_balance(@user)
              ref_code = ReferralCode.where(secret_code: referral_code).first
              code_owner = User.where(id: ref_code.user_id).first
              unless code_owner.nil?
                update_account_balance(code_owner) unless code_owner.customer_id.blank?
              end


              # if create_two_coupons(@user.id, referral_code)
              #   update_subscriptions_with_coupons(@user.id, referral_code)
                # ref_code = ReferralCode.where(secret_code: referral_code).first
                # ref_code.destroy!
              # end
            end

            @success = true
            @ref_code = ReferralCode.create_new_referral_code(@user.id)
            SendUserSignupEmailJob.perform_now(@user.id)
            SendAdminNewUserEmailJob.perform_now(@user.id)
          end
        end
      rescue ActiveRecord::RecordNotFound, ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique, ArgumentError, SecurityError
        raise ActiveRecord::Rollback
      end
    end
    if @success == true
      unless referral_code.blank?
        ref_code = ReferralCode.where(secret_code: referral_code).first
        ref_code.referral_emails << @user.email
        ref_code.referral_customer_ids << @user.customer_id
        ref_code.save!
      end
    end
  end

  private

  def _check_for_params_valid?(params: {})
    if params.is_a?(Hash) && params[:zip_code].to_i.is_a?(Numeric) && !!(params[:email] =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i)
      zip_code_service = CheckZipCode.call(params[:zip_code])
      if zip_code_service.zip_code && User.find_by(email: params[:email]) == nil && MealType.find_by!(id: params[:meal_type_id])
        return true
      end
    else
      fail(SecurityError)
    end
  end

  def _create_user_ingredients_reference!(user: , ingredient_ids: [])
    ingredient_ids ||= []
    ingredient_ids.each do |id|
      Ingredient.find_by!(id: id)
    end
    user.update_attributes!(ingredient_ids: ingredient_ids)
    return true
  end

  def _send_request_to_stripe!(user:, card_params: {})
    uri = URI.parse("https://api.stripe.com/v1/customers")
    data = {"card[number]" => card_params[:card_number], "card[exp_month]" => card_params[:card_exp_month],
            "card[exp_year]" => card_params[:card_exp_year], "card[cvc]" => card_params[:card_cvc],
            "plan" => user.plan_id, "email" => user.email, "card[name]" => card_params[:card_name],
            "description" => "#{user.first_name} #{user.last_name}",
            "trial_end" => (user.first_delivery_date.to_time + 10.hours).to_i
    }


    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.path,
                                  'Content-Type' =>'application/json',
                                  "Authorization" => "Bearer #{STRIPE_KEY}")
    request.set_form_data(data)
    response = http.request(request)
    @stripe_message = [response.code, " - ", response.message].join
    if JSON.parse(response.body)["id"] && @stripe_message == "200 - OK"
      user.update_attributes!(customer_id: JSON.parse(response.body)["sources"]["data"][0]["customer"],
                              subscription_id: JSON.parse(response.body)["subscriptions"]["data"][0]["id"])
      return true
    else
      @stripe_message = response.body
      fail(SecurityError)
    end
  end

  def create_two_coupons(current_user_id, referral_secret_code)
    ref_code = ReferralCode.where(secret_code: referral_secret_code).first

    uri = URI.parse("https://api.stripe.com/v1/coupons")
    data1 = {
        id: "#{referral_secret_code}_#{current_user_id}",
        duration: 'once',
        amount_off: '1000',
        currency: 'usd'
    }

    data2 = {
        id: "#{referral_secret_code}_#{ref_code.user_id}_#{current_user_id}",
        duration: 'once',
        amount_off: '1000',
        currency: 'usd'
    }

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.path,
                                  'Content-Type' =>'application/json',
                                  "Authorization" => "Bearer #{STRIPE_KEY}")
    request.set_form_data(data1)
    response = http.request(request)
    stripe_message = [response.code, ' - ', response.message].join
    puts 'coupon response.body 1'
    puts response.body
    return false if JSON.parse(response.body)['id'].blank? || stripe_message != '200 - OK'

    unless ref_code.user_id.nil?
      request.set_form_data(data2)
      response = http.request(request)
      stripe_message = [response.code, ' - ', response.message].join
      puts 'coupon response.body 2'
      puts response.body
      return false if JSON.parse(response.body)['id'].blank? || stripe_message != '200 - OK'
    end

    true
  end

  def update_subscriptions_with_coupons(current_user_id, referral_secret_code)
    ref_code = ReferralCode.where(secret_code: referral_secret_code).first

    user1 = User.where(id: current_user_id).first
    user2 = User.where(id: ref_code.user_id).first

    data1 = {
        coupon: "#{referral_secret_code}_#{current_user_id}"
    }
    data2 = {
        coupon: "#{referral_secret_code}_#{ref_code.user_id}_#{current_user_id}"
    }

    uri1 = URI.parse("https://api.stripe.com/v1/customers/#{user1.customer_id}/subscriptions/#{user1.subscription_id}")

    http = Net::HTTP.new(uri1.host, uri1.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri1.path,
                                  'Content-Type' =>'application/json',
                                  'Authorization' => "Bearer #{STRIPE_KEY}")
    request.set_form_data(data1)
    response = http.request(request)
    stripe_message = [response.code, ' - ', response.message].join

    puts 'response.body 1'
    puts response.body
    return false if JSON.parse(response.body)['id'].blank? || stripe_message != '200 - OK'

    unless user2.nil?
      uri2 = URI.parse("https://api.stripe.com/v1/customers/#{user2.customer_id}/subscriptions/#{user2.subscription_id}")

      http = Net::HTTP.new(uri2.host, uri2.port)
      http.use_ssl = true
      request = Net::HTTP::Post.new(uri2.path,
                                    'Content-Type' =>'application/json',
                                    'Authorization' => "Bearer #{STRIPE_KEY}")
      request.set_form_data(data2)
      response = http.request(request)
      stripe_message = [response.code, ' - ', response.message].join
      puts 'response.body 2'
      puts response.body
      return false if JSON.parse(response.body)['id'].blank? || stripe_message != '200 - OK'
    end
  end

  def update_account_balance(user)
    #   Get customer balance
    uri1 = URI.parse("https://api.stripe.com/v1/customers/#{user.customer_id}")
    http = Net::HTTP.new(uri1.host, uri1.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri1.path,
                                 'Content-Type' =>'application/json',
                                 'Authorization' => "Bearer #{STRIPE_KEY}")
    # request.set_form_data(data1)
    response = http.request(request)
    @stripe_message = [response.code, " - ", response.message].join
    if JSON.parse(response.body)["id"] && @stripe_message == "200 - OK"
      #   Update customer balance
      current_balance = JSON.parse(response.body)['account_balance']
      request = Net::HTTP::Post.new(uri1.path,
                                    'Content-Type' =>'application/json',
                                    'Authorization' => "Bearer #{STRIPE_KEY}")
      data = {
          account_balance: current_balance - 1000
      }
      request.set_form_data(data)
      response = http.request(request)
      puts 'response.body'
      puts response.body
      if JSON.parse(response.body)["id"] && @stripe_message == "200 - OK"
        return true
      else
        @stripe_message = response.body
        fail(SecurityError)
      end
    else
      @stripe_message = response.body
      fail(SecurityError)
    end
  end



end
