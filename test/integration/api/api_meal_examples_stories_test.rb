require 'test_helper'

class ApiMealExamplesStoriesTest < ActionDispatch::IntegrationTest

  setup do
    10.times do
      create(:meal_example)
    end
    @headers = { "Accept" => "application/json", "Content-Type" => "application/json" }
  end

  test "should get random meal examples " do
    get(api_meal_examples_path, @headers)
    assert_response :success
    assert_equal JSON.parse(response.body)["success"], 0
    assert_equal JSON.parse(response.body)["result"].count, 3
    assert JSON.parse(response.body)["result"].first["user_name"].present?
    assert JSON.parse(response.body)["result"].first["user_avatar"].present?
    assert JSON.parse(response.body)["result"].first["user_goals"].present?
    assert JSON.parse(response.body)["result"].first["meal_photo"].present?
    assert JSON.parse(response.body)["result"].first["meal_ingredients"].present?
  end

  test "shouldn`t get random meal exampls" do
    MealExample.destroy_all
    get(api_meal_examples_path, @headers)
    assert_equal JSON.parse(response.body)["success"], 1
    assert_equal JSON.parse(response.body)["message"], "There are no meal examples"
  end
end
