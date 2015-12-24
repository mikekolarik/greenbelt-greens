class Admin::MealExamplesController < Admin::ApplicationController
  def index
    @meal_examples = MealExample.all.page(params[:page])
  end

  def new
    @meal_example = MealExample.new
  end

  def create
    @meal_example = MealExample.new(permitted_params[:meal_example])
    if @meal_example.save
      flash[:notice] = "Success"
      redirect_to admin_meal_examples_path
    else
      flash[:notice] = "Try Again"
      render 'new'
    end
  end

  def show
    @meal_example = MealExample.find(params[:id])
  end

  def update
    @meal_example = MealExample.find(params[:id])
    if @meal_example.update_attributes(permitted_params[:meal_example])
      redirect_to admin_meal_examples_path
      flash[:notice] = "Successfully updated"
    end
  end

  def destroy
    @meal_example = MealExample.find(params[:id])
    @meal_example.destroy
    redirect_to admin_meal_examples_path
  end


  private

  def permitted_params
    { meal_example:
        params.fetch(:meal_example, {}).permit(:user_name, :user_avatar, :meal_photo, :meal_ingredients, :calories, :carbs, :fat, :protein,
                                               user_goals: [], dietary_preferences: []) }
  end
end
