class ChangeSubscriptionAndCustomerIdsToStringInUsers < ActiveRecord::Migration
  def change
    change_column :users, :customer_id, :string
    change_column :users, :subscription_id, :string
  end
end
