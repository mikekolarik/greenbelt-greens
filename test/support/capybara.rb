require 'capybara/rails'
require 'capybara/webkit'

Capybara.register_driver :webkit_allowed do |app|
  driver = Capybara::Webkit::Driver.new(app)
  driver.allow_url('*')
  driver
end
Capybara.javascript_driver = :webkit_allowed
Capybara.default_driver = :webkit_allowed

Capybara.run_server = true

Capybara.configure do |config|
  config.match = :one
  config.exact_options = true
  config.ignore_hidden_elements = true
  config.visible_text_only = true
end

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL
end

include ActionDispatch::TestProcess

FactoryGirl::SyntaxRunner.class_eval do
  include ActionDispatch::TestProcess
end
