class Admin::DietaryPreferencesController < Admin::ApplicationController

  def new
    @dietary_preference = DietaryPreference.new
  end

  def index
    @dietary_preferences = DietaryPreference.all.page(params[:page])
  end

  def show
    @dietary_preference = DietaryPreference.find(params[:id])
  end

  def create
    @dietary_preference = DietaryPreference.new(permitted_params[:dietary_preference])
    if @dietary_preference.save
      flash[:notice] = "Success"
      redirect_to admin_dietary_preferences_path
    else
      flash[:notice] = "Try Again"
      render 'new'
    end
  end

  def update
    @dietary_preference = DietaryPreference.find(params[:id])
    if @dietary_preference.update_attributes(permitted_params[:dietary_preference])
      redirect_to admin_dietary_preferences_path
      flash[:notice] = "Successfully updated"
    end
  end

  def destroy
    @dietary_preference = DietaryPreference.find(params[:id])
    @dietary_preference.destroy
    redirect_to admin_dietary_preferences_path
  end


  private

  def permitted_params
    { dietary_preference:
        params.fetch(:dietary_preference, {}).permit(:name, :picture, :remove_picture) }
  end

end
