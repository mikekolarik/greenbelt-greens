class Users::RegistrationsController < Devise::RegistrationsController
# before_filter :configure_sign_up_params, only: [:create]
# before_filter :configure_account_update_params, only: [:update]

  def registration_start
  end

  def check_zip_code
    service = CheckZipCode.call(permitted_params_for_check_zip_code[:zip_code])
    if service.zip_code == nil
      redirect_to location_rejected_path
    else
      redirect_to select_tags_path(zip_code: permitted_params_for_check_zip_code[:zip_code])
    end
  end

  def location_rejected

  end

  def select_tags
    @tags = Tag.all
    @zip_code = permitted_params_for_check_zip_code[:zip_code]
  end

  def set_tags_conditions
    @liked_tag_ids = create_array_from_string(string: params[:liked_tag_ids])
    @disliked_tag_ids = create_array_from_string(string: params[:disliked_tag_ids])
    @hated_tag_ids = create_array_from_string(string: params[:hated_tag_ids])
    @must_have_tag_ids = create_array_from_string(string: params[:must_have_tag_ids])

    @zip_code = permitted_params_for_check_zip_code[:zip_code]

    service = CheckTagConditionUniqueness.call(liked_tag_ids: @liked_tag_ids,
                                               hated_tag_ids: @hated_tag_ids,
                                               disliked_tag_ids: @disliked_tag_ids,
                                               must_have_tag_ids: @must_have_tag_ids)
    if service.success == true
      redirect_to weekly_menu_path(zip_code: @zip_code,
                                   liked_tag_ids: @liked_tag_ids,
                                   hated_tag_ids: @hated_tag_ids,
                                   disliked_tag_ids: @disliked_tag_ids,
                                   must_have_tag_ids: @must_have_tag_ids)
    else
      redirect_to select_tags_path(zip_code: params[:zip_code])
    end
  end

  def weekly_menu
    service = GenerateWeeklyMenu.call(liked_tag_ids: params[:liked_tag_ids],
                                      hated_tag_ids: params[:hated_tag_ids],
                                      disliked_tag_ids: params[:disliked_tag_ids],
                                      must_have_tag_ids: params[:must_have_tag_ids])
    @weekly_menu = service.weekly_menu
    @zip_code = permitted_params_for_check_zip_code[:zip_code]
  end

  def generate_user_weekly_menu
    service = GenerateUserWeeklyMenu.call(monday_meal: params[:monday_meal], tuesday_meal: params[:tuesday_meal],
                                          wednesday_meal: params[:wednesday_meal], thursday_meal: params[:thursday_meal], friday_meal: params[:friday_meal])
    @user_weekly_menu = service.user_weekly_menu
    redirect_to meal_plans_path
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.for(:sign_up) << :attribute
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.for(:account_update) << :attribute
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  def create_array_from_string(string)
    array = []
    unless string.blank?
      array = string.split(',').collect! {|n| n.to_i}
    end
    return array
  end

  def permitted_params_for_check_zip_code
    params.permit(:zip_code)
  end
end
