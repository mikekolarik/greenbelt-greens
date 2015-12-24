class CreateUsersAndDietaryGoals < ActiveRecord::Migration
  def change
    create_table :dietary_goals do |t|
      t.string :name
      t.integer :sort_number
      t.timestamps null: false
    end

    create_table :dietary_goals_users, id: false do |t|
      t.belongs_to :user, index: true
      t.belongs_to :dietary_goal, index: true
    end
  end
end
