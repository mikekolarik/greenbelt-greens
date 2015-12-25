class AddDiscountValueToCommonParam < ActiveRecord::Migration
  def change
    add_column :common_params, :discount_value, :integer, default: 1000
    add_column :referral_codes, :discount_value, :integer
  end
end
