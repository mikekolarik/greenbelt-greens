class Api::ReferralCodesController < ApplicationController
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }
  respond_to :json

  def check_code_validity
    ref_code = ReferralCode.where(secret_code: params[:referral_code]).first
    unless ref_code.blank?
      discount_value = ref_code.discount_value || CommonParam.get_param('discount_value')
      render json: {
                 success: 0,
                 result: {
                     discount: discount_value
                 }
             }
    else
      render json: { success: 1, message: 'Failed to find referral code' }
    end
  end





end
