class IntroScreenBlock < ActiveRecord::Base
  validates :title, length: { maximum: 128, too_long: "%{count} characters is the maximum allowed" }
  validates :description, length: { maximum: 512, too_long: "%{count} characters is the maximum allowed" }

  mount_uploader :picture, IntroScreenPictureUploader
end
