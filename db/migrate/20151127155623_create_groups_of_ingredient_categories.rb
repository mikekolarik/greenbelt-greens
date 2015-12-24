class CreateGroupsOfIngredientCategories < ActiveRecord::Migration
  def change
    create_table :categories_groups do |t|
      t.string :name
      t.timestamps null: false
    end
  end
end
