class Api::SignUpController < ApplicationController
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }

  respond_to :json

  def create
    service = CreateUser.call(user_params: permitted_params[:user], card_params: permitted_params_for_card[:user], referral_code: params[:user][:referral_code])
    if service.success
      render :json => {
                 :success => 0,
                 :result => {
                     user: service.user,
                     referral_code: service.ref_code.secret_code
                 },
                 :message => service.stripe_message}
    else
      if service.user.errors.full_messages.count > 0
        render :json => {:success => 1, :message => {
                     error: {
                         message: service.user.errors.full_message
                     }
                 }
               }
      elsif service.stripe_message
        render :json => {:success => 2, :message => service.stripe_message}
      else
        render :json => {:success => 3, :message => '{"error": {"code": "wrong_params",  "message": "Wrong parameters. Perhaps, email address was already used"}}'}
      end
    end
  end

  def check_if_user_exists
    user = User.where(email: params[:email]).first
    puts 'user'
    puts user
    if user.nil?
      render json: { success: 0 }
    else
      render json: { success: 3, message: 'User already exists' }
    end
  end

  def permitted_params
    { user:
        params.fetch(:user, {}).permit(:first_name, :last_name, :zip_code, :email,
                                       :address1, :address2, :meal_type_id, :weekend_delivery_range, :weekday_delivery_range,
                                       :delivery_instructions, :phone, :plan_id, :facebook_id, :first_delivery_date, :total_amount, :number_of_meals,
                                       :password, ingredient_ids: [])}
  end

  def permitted_params_for_card
    { user:
        params.fetch(:user, {}).permit(:card_cvc, :card_number, :card_exp_year, :card_exp_month, :card_name)}
  end
end
