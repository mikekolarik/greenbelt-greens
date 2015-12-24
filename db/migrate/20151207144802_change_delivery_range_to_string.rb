class ChangeDeliveryRangeToString < ActiveRecord::Migration
  def change
    change_column :users, :delivery_range, :string
  end
end
