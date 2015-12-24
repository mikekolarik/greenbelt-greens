class Ingredient < ActiveRecord::Base
  self.table_name = 'ingredients'
  belongs_to :ingredient_category
  has_and_belongs_to_many :dietary_goals
  has_and_belongs_to_many :dietary_preferences
  has_and_belongs_to_many :users

  validates_presence_of :name
  validates_uniqueness_of :name
end
