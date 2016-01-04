class SubscribeUserToAbandonedListJob < ActiveJob::Base
  queue_as :default

  def perform(user_email)
    begin
      gb = Gibbon::Request.new
      gb.lists(MAILCHIMP_ABANDONED_LIST_ID).members.create(body: {email_address: user_email, status: "subscribed"})
    rescue
    end
    return true
  end
end
