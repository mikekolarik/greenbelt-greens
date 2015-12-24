require 'test_helper'

class ApiDietaryGoalsStoriesTest < ActionDispatch::IntegrationTest

  setup do
    @dietary_goal = create(:dietary_goal)
    @headers = { "Accept" => "application/json", "Content-Type" => "application/json" }
  end

  test "should get list of dietary goals" do
    get(api_dietary_goals_path, @headers)
    assert_response :success
    assert_equal JSON.parse(response.body)["success"], 0
    assert JSON.parse(response.body)["result"].first["name"].present?
    assert JSON.parse(response.body)["result"].first["picture"].present?
  end

  test "shouldn`t get list without dietary goals in db" do
    DietaryGoal.destroy_all
    get(api_dietary_goals_path, @headers)
    assert_equal JSON.parse(response.body)["success"], 1
    assert_equal JSON.parse(response.body)["message"], "Can`t find any dietary goals"
  end
end
