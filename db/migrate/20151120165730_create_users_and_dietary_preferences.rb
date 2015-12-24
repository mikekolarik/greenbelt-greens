class CreateUsersAndDietaryPreferences < ActiveRecord::Migration
  def change
    create_table :dietary_preferences do |t|
      t.string :name
      t.integer :sort_number
      t.timestamps null: false
    end

    create_table :dietary_preferences_users, id: false do |t|
      t.belongs_to :user, index: true
      t.belongs_to :dietary_preference, index: true
    end
  end
end
