class CategoriesGroup < ActiveRecord::Base
  self.table_name = 'categories_groups'
  has_many :ingredient_categories

  validates_presence_of :name
  validates_uniqueness_of :name
end
