class ZipCodeRange < ActiveRecord::Base
  self.table_name = 'zip_code_ranges'
  validates :zip_from, presence: true, numericality: true #, uniqueness: true
  validates :zip_to, presence: true, numericality: true #, uniqueness: true

  validates_length_of :zip_from, :minimum => 4, :maximum => 5, :allow_blank => false
  validates_length_of :zip_to, :minimum => 4, :maximum => 5, :allow_blank => false

  #validates :zip_to, numericality: { greater_than: :zip_from }
end
