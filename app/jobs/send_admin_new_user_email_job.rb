class SendAdminNewUserEmailJob < ActiveJob::Base
  queue_as :default

  def perform(user_id)
    UserMailer.admin_email(user_id).deliver
  end
end
