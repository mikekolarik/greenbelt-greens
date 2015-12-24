class IngredientCategory < ActiveRecord::Base
  self.table_name = 'ingredient_categories'
  has_many :ingredients
  belongs_to :categories_group

  validates_presence_of :name
  validates_uniqueness_of :name
end
