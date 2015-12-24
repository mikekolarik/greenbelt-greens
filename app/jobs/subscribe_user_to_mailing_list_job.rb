class SubscribeUserToMailingListJob < ActiveJob::Base
  queue_as :default

  def perform(new_area)
    begin
      gb = Gibbon::Request.new
      gb.lists(MAILCHIMP_LIST_ID).members.create(body: {email_address: new_area.user_email, status: "subscribed", merge_fields: {ZIPCODE: new_area.user_zip_code}})
    rescue
    end
    return true
  end
end
