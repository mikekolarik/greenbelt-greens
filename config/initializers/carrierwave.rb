require 'carrierwave'
require 'carrierwave/orm/activerecord'

if Rails.env.production?
  CarrierWave.configure do |config|
    config.storage = :fog
    config.fog_credentials = {
      provider:              'AWS', # required
      aws_access_key_id:     'AKIAIQK73QGV65SRWD3A', # required
      aws_secret_access_key: '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', # required
      region: 'us-west-1'
    }
    config.fog_directory  = 'greenbeltgreensuploads' # required
  end

else
  CarrierWave.configure do |config|
    config.storage = :file
  end

  # make sure our uploader is auto-loaded
  IntroScreenPictureUploader
  UserAvatarUploader
  MealPhotoUploader
  DietaryGoalPictureUploader
  DietaryPreferencePictureUploader

  if Rails.env.development?
    # use different dirs when testing
    CarrierWave::Uploader::Base.descendants.each do |klass|
      next if klass.anonymous?
      klass.class_eval do
        def cache_dir
          "#{Rails.root}/uploads"
        end

        def store_dir
          "#{Rails.root}/public/uploads/content/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
        end
      end
    end

  else
    CarrierWave::Uploader::Base.descendants.each do |klass|
      next if klass.anonymous?
      klass.class_eval do
        def cache_dir
          "#{Rails.root}/uploads"
        end

        def store_dir
          "#{Rails.root}/public/uploads/tmp/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
        end
      end
    end
  end

end
