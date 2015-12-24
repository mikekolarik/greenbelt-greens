class PopoverContent < ActiveRecord::Base
  validates_presence_of :content

  mount_uploader :picture, IntroScreenPictureUploader
end
