class MealType < ActiveRecord::Base
  self.table_name = 'meal_types'
  has_many :users
  validates :key, length: { maximum: 128, too_long: "%{count} characters is the maximum allowed" }
  validates :description, length: { maximum: 512, too_long: "%{count} characters is the maximum allowed" }
  validates_presence_of :key, :description
end
