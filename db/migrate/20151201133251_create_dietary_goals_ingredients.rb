class CreateDietaryGoalsIngredients < ActiveRecord::Migration
  def change
    create_table :dietary_goals_ingredients, id: false do |t|
      t.belongs_to :ingredient, index: true
      t.belongs_to :dietary_goal, index: true
    end
  end
end
