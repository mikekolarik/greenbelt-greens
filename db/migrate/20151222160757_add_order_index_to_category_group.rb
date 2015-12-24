class AddOrderIndexToCategoryGroup < ActiveRecord::Migration
  def change
    add_column :categories_groups, :order_index, :integer, default: 0
  end
end
