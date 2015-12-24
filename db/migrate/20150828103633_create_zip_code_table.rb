class CreateZipCodeTable < ActiveRecord::Migration
  def change
    create_table :zip_codes do |t|
      t.integer :from
      t.integer :to

      t.timestamps null: false
    end
  end
end
