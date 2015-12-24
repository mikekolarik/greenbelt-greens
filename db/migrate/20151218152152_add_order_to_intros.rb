class AddOrderToIntros < ActiveRecord::Migration
  def change
    add_column :intro_screen_blocks, :order_index, :integer, default: 0
  end
end
