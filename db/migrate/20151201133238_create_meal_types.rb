class CreateMealTypes < ActiveRecord::Migration
  def change
    create_table :meal_types do |t|
      t.string :key
      t.text :description

      t.timestamps null: false
    end
  end
end
