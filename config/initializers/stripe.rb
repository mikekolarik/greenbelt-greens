STRIPE_KEY = if Rails.env.development? || Rails.env.test?
  "sk_test_2CjjCTBPa6rxoCvRjQJNrywT"
else
  ENV['STRIPE_KEY']
end