class SendUserSignupEmailJob < ActiveJob::Base
  queue_as :default

  def perform(user_id)
    UserMailer.user_email(user_id).deliver
  end
end
