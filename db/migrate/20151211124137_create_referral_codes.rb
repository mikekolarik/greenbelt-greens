class CreateReferralCodes < ActiveRecord::Migration
  def up
    unless table_exists? :referral_codes
      create_table :referral_codes do |t|
        t.string :secret_code
        t.integer :user_id

        t.timestamps null: false
      end
    end

    if table_exists? :popover_contents
      remove_column :popover_contents, :page_key if column_exists? :popover_contents, :page_key
      add_column :popover_contents, :order_index, :integer, default: 0 unless column_exists? :popover_contents, :order_index
    end

    if table_exists? :users
      add_column :users, :referral_code_id, :integer unless column_exists? :users, :referral_code_id
    end
  end

  def down
    drop_table :referral_codes if table_exists? :referral_codes
    if table_exists? :popover_contents
      remove_column :popover_contents, :order_index if column_exists? :popover_contents, :order_index
    end
    if table_exists? :users
      remove_column :users, :referral_code_id if column_exists? :users, :referral_code_id
    end
  end
end
