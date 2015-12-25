class Admin::ReferralCodesController < Admin::ApplicationController

  def new
    @referral_code = ReferralCode.new
  end

  def index
    @referral_codes = ReferralCode.all.page(params[:page])
  end

  def show
    @referral_code = ReferralCode.find(params[:id])
  end

  def create
    @referral_code = ReferralCode.new(permitted_params[:referral_code])
    @referral_code.user_id = current_user.id
    @referral_code.owner_email = current_user.email
      if @referral_code.save
        redirect_to admin_referral_codes_path, notice: "Success"
      else
        flash[:notice] = "Try Again"
        render 'new'
      end
  end

  def update
    @referral_code = ReferralCode.find(params[:id])
    if @referral_code.update_attributes(permitted_params[:referral_code])
      redirect_to admin_referral_codes_path, notice: "Successfully updated"
    end
  end

  def destroy
    @referral_code = ReferralCode.find(params[:id])
    @referral_code.destroy
    redirect_to admin_referral_codes_path, notice: "Successfully deleted"
  end


  private

  def permitted_params
      { referral_code:
          params.fetch(:referral_code, {}).permit(:secret_code, :discount_value) }
  end
end
