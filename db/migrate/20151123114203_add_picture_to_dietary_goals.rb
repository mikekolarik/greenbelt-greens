class AddPictureToDietaryGoals < ActiveRecord::Migration
  def change
    add_column :dietary_goals, :picture, :string
  end
end
