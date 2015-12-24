class ActionDispatch::IntegrationTest

  setup do
    @user = create(:user)
    @user.update!(admin: true)
  end

  module CustomIntegrationDsl
    def use_js
      Capybara.current_driver = Capybara.javascript_driver
    end

    def login
      use_js
      visit new_user_session_path
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password

      click_button 'Sign In'
    end
  end

  include CustomIntegrationDsl

  teardown do
    FileUtils.rm_rf(Dir["#{Rails.root}/public/uploads/tmp"])
  end
end
