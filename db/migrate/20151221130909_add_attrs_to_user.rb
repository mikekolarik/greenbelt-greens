class AddAttrsToUser < ActiveRecord::Migration
  def change
    add_column :users, :first_delivery_date, :date
    add_column :users, :total_amount, :decimal, default: 0
    add_column :users, :number_of_meals, :integer
  end
end
