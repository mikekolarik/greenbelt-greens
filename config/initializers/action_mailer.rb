if Rails.env.development? || Rails.env.test? || Rails.env.production?
  SMTP_ADDRESS  = 'smtp.mandrillapp.com'
  SMTP_DOMAIN   = 'greenbeltgreens.com'
  SMTP_PASSWORD = Rails.env.development? ? '9PVz6xAJtMm6X5LZ2CQKeQ' : ENV['MANDRILL_APIKEY']    # '9PVz6xAJtMm6X5LZ2CQKeQ'
  SMTP_USERNAME = Rails.env.development? ? 'app44267128@heroku.com' : ENV['MANDRILL_USERNAME']  # 'app44267128@heroku.com'
  ADMIN_EMAIL   = 'admin@greenbeltgreens.com'

  Rails.application.configure do
    config.action_mailer.smtp_settings = {
      address: SMTP_ADDRESS,
      authentication: :plain,
      domain: SMTP_DOMAIN,
      enable_starttls_auto: true,
      password: SMTP_PASSWORD,
      port: '587', # 2525, 587, 25
      user_name: SMTP_USERNAME
    }
    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.perform_deliveries = true
    config.action_mailer.default_url_options = { host: SMTP_DOMAIN }
  end
end
