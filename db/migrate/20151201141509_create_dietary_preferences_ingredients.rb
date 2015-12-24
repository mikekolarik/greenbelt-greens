class CreateDietaryPreferencesIngredients < ActiveRecord::Migration
  def change
    create_table :dietary_preferences_ingredients, id: false do |t|
      t.belongs_to :ingredient, index: true
      t.belongs_to :dietary_preference, index: true
    end
  end
end
