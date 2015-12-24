require 'test_helper'

class ApiZipCodeStoriesTest < ActionDispatch::IntegrationTest

  setup do
    @zip_code_range = ZipCodeRange.create(zip_from: 1000, zip_to: 2000)
    @success_params = {validation: {zip_code: 1001}}.to_json
    @wrong_params = {validation: {zip_code: "wrong"}}.to_json
    @not_existing_params = {validation: {zip_code: 100}}.to_json
    @headers = { "Accept" => "application/json", "Content-Type" => "application/json" }
  end

  test "should be valid" do
    post(api_check_for_valid_path, @success_params, @headers)
    assert_response :success
    assert_equal JSON.parse(response.body)["success"], 0
  end

  test "should not be valid" do
    post(api_check_for_valid_path, @not_existing_params, @headers)
    assert_response 200
    assert_equal JSON.parse(response.body)["success"], 1
  end

  test "should crush" do
    assert_raise(ActiveRecord::StatementInvalid) do
      post(api_check_for_valid_path, @wrong_params, @headers)
    end
  end
end
