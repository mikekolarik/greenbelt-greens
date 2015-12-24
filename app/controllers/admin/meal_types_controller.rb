class Admin::MealTypesController < Admin::ApplicationController

  def new
    @meal_type = MealType.new
  end

  def index
    @meal_types = MealType.all.page(params[:page])
  end

  def show
    @meal_type = MealType.find(params[:id])
  end

  def create
    @meal_type = MealType.new(permitted_params[:meal_type])
      if @meal_type.save
        redirect_to admin_meal_types_path, notice: "Success"
      else
        flash[:notice] = "Try Again"
        render 'new'
      end
  end

  def update
    @meal_type = MealType.find(params[:id])
    if @meal_type.update_attributes(permitted_params[:meal_type])
      redirect_to admin_meal_types_path, notice: "Successfully updated"
    end
  end

  def destroy
    @meal_type = MealType.find(params[:id])
    @meal_type.destroy
    redirect_to admin_meal_types_path, notice: "Successfully deleted"
  end


  private

  def permitted_params
      { meal_type:
          params.fetch(:meal_type, {}).permit(:key, :description, :order) }
  end
end
