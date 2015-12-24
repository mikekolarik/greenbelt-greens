class AddPictureToDietaryPreferences < ActiveRecord::Migration
  def change
    add_column :dietary_preferences, :picture, :string
  end
end
