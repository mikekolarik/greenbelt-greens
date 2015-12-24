class AddGroupIdToIngredientCategories < ActiveRecord::Migration
  def change
    add_column :ingredient_categories, :categories_group_id, :integer
  end
end
