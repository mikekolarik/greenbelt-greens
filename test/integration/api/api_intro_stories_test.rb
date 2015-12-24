require 'test_helper'

class ApiIntroStoriesTest < ActionDispatch::IntegrationTest

  setup do
    @intro_screen_block = create(:intro_screen_block)
    @headers = { "Accept" => "application/json", "Content-Type" => "application/json" }
  end

  test "should get data of intro screen blocks" do
    get(api_intro_path, @headers)
    assert_response :success
    assert_equal JSON.parse(response.body)["success"], 0
    assert JSON.parse(response.body)["result"].first["title"].present?
    assert JSON.parse(response.body)["result"].first["description"].present?
    assert JSON.parse(response.body)["result"].first["picture"].present?
  end

  test "shouldn`t get data without intro screen blocks in db" do
    IntroScreenBlock.destroy_all
    get(api_intro_path, @headers)
    assert_equal JSON.parse(response.body)["success"], 1
    assert_equal JSON.parse(response.body)["message"], "Can`t find any intro screen blocks"
  end
end
