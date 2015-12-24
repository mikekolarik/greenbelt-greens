require 'test_helper'

class ApiRegistrationStoriesTest < ActionDispatch::IntegrationTest

  setup do
    @user_params = {"user" => {"email" => "example@email.com", "password" => "example_password", "password_confirmation" => "example_password"}}.to_json
    @wrong_params = {"user" => {"email" => "wronguseremail", "password" => "example_password", "password_confirmation" => "wrong_password"}}.to_json
    @headers = { "Accept" => "application/json", "Content-Type" => "application/json" }
  end

  test "should register" do
    post(api_register_path, @user_params, @headers)
    assert_response :success
    assert JSON.parse(response.body)["data"]["auth_token"].present?
    assert_equal JSON.parse(response.body)["success"], 0
  end

  test "should not register with wrong user params " do
    post(api_register_path, @wrong_params, @headers)
    assert_equal JSON.parse(response.body)["success"], 1
    assert_response 422
  end

  test "should not register with nil params" do
    post(api_register_path, nil, nil)
    assert_equal JSON.parse(response.body)["success"], 1
    assert_response 422
  end
end
