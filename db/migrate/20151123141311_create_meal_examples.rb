class CreateMealExamples < ActiveRecord::Migration
  def change
    create_table :meal_examples do |t|
      t.string :user_name
      t.string :user_avatar
      t.text :user_goals, array: true, default: []
      t.string :meal_photo
      t.text :meal_ingredients

      t.timestamps null: false
    end
  end
end
