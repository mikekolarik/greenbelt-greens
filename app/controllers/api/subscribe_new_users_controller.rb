class Api::SubscribeNewUsersController < ApplicationController
  skip_before_filter :verify_authenticity_token,
                    :if => Proc.new { |c| c.request.format == 'application/json' }

  respond_to :json

  def subscribe_user
    subscription = NewArea.new(permitted_params[:subscription])
    if subscription.save!
      ref_code = ReferralCode.create_new_referral_code
      ref_code.owner_email = permitted_params[:subscription][:user_email]
      ref_code.save!
      render :json => {
                 :success => 0,
                 :result => {
                     subscription: subscription,
                     referral_code: ref_code.secret_code
                 }
             }
    else
      render :json => {:success => 1, :message => "Sorry, try again"}
    end
  end


  def permitted_params
    { subscription:
        params.fetch(:subscription, {}).permit(:user_email, :user_zip_code)}
  end
end
