require 'test_helper'

class ApiSignInStoriesTest < ActionDispatch::IntegrationTest

  setup do
    @user = create(:user)
    @user_params = {"user" => {"email" => @user.email, "password" => @user.password, "remember_me"=>"0"}}.to_json
    @wrong_params = {"user" => {"email" => "wrong@user.email", "password" => "wrong_password", "remember_me"=>"0"}}.to_json
    @headers = { "Accept" => "application/json", "Content-Type" => "application/json" }
  end

  test "should sign in" do
    post(api_login_path, @user_params, @headers)
    assert_response :success
    assert JSON.parse(response.body)["data"]["auth_token"].present?
    assert_equal JSON.parse(response.body)["success"], 0
  end

  test "should not sign in without header" do
    post(api_login_path, @user_params, nil)
    assert_equal JSON.parse(response.body)["success"], 1
    assert_response 401
  end

# SCORE-1
  test "should not sign in with wrong user params " do
    post(api_login_path, @wrong_params, @headers)
    assert_equal JSON.parse(response.body)["success"], 1
    assert_response 401
  end

  test "should not sign in with nil params" do
    post(api_login_path, nil, nil)
    assert_equal JSON.parse(response.body)["success"], 1
    assert_response 401
  end
end
