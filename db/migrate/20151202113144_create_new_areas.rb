class CreateNewAreas < ActiveRecord::Migration
  def change
    create_table :new_areas do |t|
      t.string :user_email
      t.string :user_zip_code

      t.timestamps null: false
    end
  end
end
