class Admin::UsersController < Admin::ApplicationController

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
    @user = User.find(params[:id])
    if @user.update_attributes!(permitted_params[:user])
      @user.update_attributes!(ingredient_ids: permitted_params_for_ingredients[:user][:ingredient_ids])
      flash[:notice] = "User successfully updated."
      redirect_to admin_users_path
    else
      flash[:notice] = "Try Again"
      render 'edit'
    end
  end

  def index
    @users = User.all
  end

  def create
    @user = User.new(permitted_params[:user])
    if @user.save
      @user.update!(admin: true)
      flash[:notice] = "Success"
      redirect_to admin_users_path
    else
      flash[:notice] = "Try Again"
      render 'new'
    end
  end

  def list_of_admins
    @users = User.all.where("admin", true)
    render 'index'
  end

  def switch_value
    @user = User.find(params[:id])
    if @user.admin?
      @user.update!(admin: false)
    else
      @user.update!(admin: true)
    end
    redirect_to admin_users_path
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_path
  end

  private

  def permitted_params
    { user:
        params.fetch(:user, {}).permit(:first_name, :last_name, :zip_code,
                                       :email, :address1, :address2,
                                       :weekend_delivery_range, :weekday_delivery_range, :delivery_instructions, :phone,
                                       :meal_type_id, :password, :password_confirmation,
                                       :admin, :active) }
  end

  def permitted_params_for_ingredients
  { user:
      params.permit(ingredient_ids: []) }
  end
end
