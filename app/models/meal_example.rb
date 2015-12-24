class MealExample < ActiveRecord::Base
  validates :user_name, presence: true, uniqueness: true
  validates :user_goals, presence: true
  validates :meal_ingredients, presence: true

  mount_uploader :meal_photo, MealPhotoUploader
  validates :meal_photo, presence: true

  mount_uploader :user_avatar, UserAvatarUploader
  validates :user_avatar, presence: true
end
