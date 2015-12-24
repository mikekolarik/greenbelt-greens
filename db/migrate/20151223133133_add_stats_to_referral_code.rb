class AddStatsToReferralCode < ActiveRecord::Migration
  def change
    add_column :referral_codes, :referral_emails, :string, array: true, default: []
    add_column :referral_codes, :referral_customer_ids, :string, array: true, default: []
  end
end
