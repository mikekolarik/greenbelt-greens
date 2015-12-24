class Admin::IngredientCategoriesController < Admin::ApplicationController

  def index
    @ingredient_categories = IngredientCategory.all.page(params[:page])
  end

  def show
    @ingredient_category = IngredientCategory.find(params[:id])
  end

  def new
    @ingredient_category = IngredientCategory.new
  end

  def create
    @ingredient_category = IngredientCategory.new(permitted_params[:ingredient_category])
    if @ingredient_category.save
      flash[:notice] = "Category was successfully created"
      redirect_to admin_ingredient_categories_path
    else
      flash[:notice] = "Something went wrong"
      render 'new'
    end
  end

  def update
    @ingredient_category = IngredientCategory.find(params[:id])
    if @ingredient_category.update_attributes(permitted_params[:ingredient_category])
      flash[:notice] = "Category was successfully updated"
      redirect_to admin_ingredient_categories_path
    else
      flash[:notice] = "Something went wrong"
      render 'show'
    end
  end

  def destroy
    @ingredient_category = IngredientCategory.find(params[:id])
    @ingredient_category.destroy
    flash[:notice] = "Category was successfully deleted"
    redirect_to admin_ingredient_categories_path
  end

  def import
    count = IngredientCategory.count
    ImportIngredientCategoriesFromCsv.call(permitted_params_for_import_csv[:csv_file_with_ingredient_category])
    if count == IngredientCategory.count
      redirect_to admin_ingredient_categories_path, notice: "Nothing to import"
    else
      redirect_to admin_ingredient_categories_path, notice: "Ingredient Categories was successfully imported"
    end
  end

  private

  def permitted_params
    { ingredient_category:
        params.fetch(:ingredient_category, {}).permit(:name) }
  end

  def permitted_params_for_import_csv
    params.permit(:csv_file_with_ingredient_category)
  end
end
