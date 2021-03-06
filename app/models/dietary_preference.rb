class DietaryPreference < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_and_belongs_to_many :ingredients

  validates :name, presence: true, uniqueness: true

  mount_uploader :picture, DietaryPreferencePictureUploader
  validates :picture, presence: true, on: :create
end
