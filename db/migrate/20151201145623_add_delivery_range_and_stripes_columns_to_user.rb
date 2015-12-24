class AddDeliveryRangeAndStripesColumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :address1, :string
    add_column :users, :address2, :string
    add_column :users, :phone, :string
    add_column :users, :delivery_instructions, :text
    add_column :users, :customer_id, :integer
    add_column :users, :plan_id, :integer
    add_column :users, :subscription_id, :integer
    add_column :users, :facebook_id, :string
    add_column :users, :meal_type_id, :integer
    add_column :users, :delivery_range, :string
  end
end
