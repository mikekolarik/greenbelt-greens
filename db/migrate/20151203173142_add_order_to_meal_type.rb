class AddOrderToMealType < ActiveRecord::Migration
  def change
    add_column :meal_types, :order, :integer, default: 0
  end
end
