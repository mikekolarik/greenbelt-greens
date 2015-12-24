require 'test_helper'

class ApiDietaryPreferencesStoriesTest < ActionDispatch::IntegrationTest

  setup do
    @dietary_preference = create(:dietary_preference)
    @headers = { "Accept" => "application/json", "Content-Type" => "application/json" }
  end

  test "should get list of dietary preferences" do
    get(api_dietary_preferences_path, @headers)
    assert_response :success
    assert_equal JSON.parse(response.body)["success"], 0
    assert JSON.parse(response.body)["result"].first["name"].present?
    assert JSON.parse(response.body)["result"].first["picture"].present?
  end

  test "shouldn`t get list without dietary preferences in db" do
    DietaryPreference.destroy_all
    get(api_dietary_preferences_path, @headers)
    assert_equal JSON.parse(response.body)["success"], 1
    assert_equal JSON.parse(response.body)["message"], "Can`t find any dietary preferences"
  end
end
