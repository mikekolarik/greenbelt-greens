class RemoveUserFromAbandonedListJob < ActiveJob::Base
  queue_as :default

  def perform(user_email)
    begin
      lower_case_md5_hashed_email_address = Digest::MD5.hexdigest(user_email)
      gb = Gibbon::Request.new
      gb.lists(MAILCHIMP_ABANDONED_LIST_ID).members(lower_case_md5_hashed_email_address).delete
    rescue
    end
    return true
  end
end
