if Rails.env.development? || Rails.env.test? || Rails.env.production?
  MAILCHIMP_API_KEY = "9b5d8aa190650280a9b0c43b4f25013a-us12"
  MAILCHIMP_LIST_ID = "0e28c476e7"

  Gibbon::Request.api_key = MAILCHIMP_API_KEY
  Gibbon::Request.timeout = 15
  Gibbon::Request.throws_exceptions = true
end
