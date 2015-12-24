class HelpBlock < ActiveRecord::Base
  validates :key, length: { maximum: 128, too_long: "%{count} characters is the maximum allowed" }
  validates :description, length: { maximum: 512, too_long: "%{count} characters is the maximum allowed" }
  validates_presence_of :key, :description
end
