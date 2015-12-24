require 'test_helper'

class AdminSessionsStoriesTest < ActionDispatch::IntegrationTest

  setup do
    @regular_user = create(:user)
  end

  test "should sign in admin and redirect to intro_screen_blocks" do
    visit new_user_session_path
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    click_button 'Sign In'
    assert page.has_content? "Signed in successfully."
    assert page.has_content? "Intro Screen Blocks"
  end

  test "should not redirect regular_user to intro_screen_blocks" do
    visit new_user_session_path
    fill_in 'Email', with: @regular_user.email
    fill_in 'Password', with: @regular_user.password
    click_button 'Sign In'
    assert page.has_content? "Signed in successfully."
    assert page.has_content? "Sorry, you are not admin"
  end

  test "should not pass to ingredients_path" do
    visit admin_ingredients_path
    assert page.has_content? 'You need to sign in or sign up before continuing.'
    assert page.has_content? 'Sign In'
  end

  test "should sign out" do
    login
    assert page.has_content? "Intro Screen Blocks"
    click_link 'Sign Out'
    assert page.has_content? 'Sign In'
  end
end
