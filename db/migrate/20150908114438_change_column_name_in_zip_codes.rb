class ChangeColumnNameInZipCodes < ActiveRecord::Migration
  def change
    rename_table(:zip_codes, :zip_code_ranges)
    rename_column :zip_code_ranges, :from, :zip_from
    rename_column :zip_code_ranges, :to, :zip_to
  end
end
