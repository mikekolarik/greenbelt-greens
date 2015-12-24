class Admin::IngredientsController < Admin::ApplicationController

  def index
    @ingredients = Ingredient.all.page(params[:page])
  end

  def show
    @ingredient = Ingredient.includes(:dietary_goals, :dietary_preferences).find(params[:id])
  end

  def new
    @ingredient = Ingredient.new
  end

  def create
    @ingredient = Ingredient.new(permitted_params[:ingredient])
    if @ingredient.save
      flash[:notice] = "Ingredient was successfully created"
      redirect_to admin_ingredients_path
    else
      flash[:notice] = "Something went wrong"
      render 'new'
    end
  end

  def update
    @ingredient = Ingredient.find(params[:id])
    if @ingredient.update_attributes(permitted_params[:ingredient])
      flash[:notice] = "Ingredient was successfully updated"
      redirect_to admin_ingredients_path
    else
      flash[:notice] = "Something went wrong"
      render 'show'
    end
  end

  def destroy
    @ingredient = Ingredient.find(params[:id])
    @ingredient.destroy
    flash[:notice] = "Ingredient was successfully deleted"
    redirect_to admin_ingredients_path
  end

  def import
    count = Ingredient.count
    ImportIngredientsFromCsv.call(permitted_params_for_import_csv[:csv_file_with_ingredient])
    if count == Ingredient.count
      redirect_to admin_ingredients_path, notice: "Nothing to import"
    else
      redirect_to admin_ingredients_path, notice: "Ingredients successfully imported"
    end
  end

  private

  def permitted_params
    { ingredient:
        params.fetch(:ingredient, {}).permit(:name, :ingredient_category_id, dietary_goal_ids: [], dietary_preference_ids: []) }
  end

  def permitted_params_for_import_csv
    params.permit(:csv_file_with_ingredient)
  end
end
