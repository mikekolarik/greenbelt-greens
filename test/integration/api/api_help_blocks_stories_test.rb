require 'test_helper'

class ApiHelpBlocksStoriesTest < ActionDispatch::IntegrationTest

  setup do
    @help_block = create(:help_block)
    @headers = { "Accept" => "application/json", "Content-Type" => "application/json" }
  end

  test "should get data of help blocks" do
    get(api_help_blocks_path, @headers)
    assert_response :success
    assert_equal JSON.parse(response.body)["success"], 0
    assert JSON.parse(response.body)["result"].first["id"].present?
    assert JSON.parse(response.body)["result"].first["key"].present?
    assert JSON.parse(response.body)["result"].first["description"].present?
  end

  test "shouldn`t get data without intro screen blocks in db" do
    HelpBlock.destroy_all
    get(api_help_blocks_path, @headers)
    assert_equal JSON.parse(response.body)["success"], 1
    assert_equal JSON.parse(response.body)["message"], "Can`t find any help blocks"
  end
end
