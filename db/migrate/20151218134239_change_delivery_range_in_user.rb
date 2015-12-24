class ChangeDeliveryRangeInUser < ActiveRecord::Migration

  def up
    if table_exists? :users
      remove_column :users, :delivery_range if column_exists? :users, :delivery_range
      add_column :users, :weekend_delivery_range, :string unless column_exists? :users, :weekend_delivery_range
      add_column :users, :weekday_delivery_range, :string unless column_exists? :users, :weekday_delivery_range
    end
  end

  def down
    if table_exists? :users
      add_column :users, :delivery_range, :string unless column_exists? :users, :delivery_range
      remove_column :users, :weekend_delivery_range, :string if column_exists? :users, :weekend_delivery_range
      remove_column :users, :weekday_delivery_range, :string if column_exists? :users, :weekday_delivery_range
    end
  end

end
