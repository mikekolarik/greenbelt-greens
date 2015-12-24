require 'test_helper'

class UserMailerTest < ActionMailer::TestCase


  def setup
    @user = create(:user)
  end

  test "test send signup email to user" do
    mail = UserMailer.user_email(@user.id)
    assert_equal "Welcome to our awesome app!", mail.subject
    assert_equal [@user.email], mail.to
    assert_equal ["hello@example.com"], mail.from
  end

  test "test send new user email to admin" do
    mail = UserMailer.admin_email(@user.id)
    assert_equal "New User in system app!", mail.subject
    assert_equal [ADMIN_EMAIL], mail.to
    assert_equal ["hello@example.com"], mail.from
  end
end
