require 'test_helper'

class ApiSignUpStoriesTest < ActionDispatch::IntegrationTest

  setup do
    @meal_type = create(:meal_type)
    @zip_code_range = create(:zip_code_range)
    @ingredient_category = create(:ingredient_category)
    @ingredient = create(:ingredient, ingredient_category: @ingredient_category)
    @ingredient2 = create(:ingredient, ingredient_category: @ingredient_category)
    @success_params = {user:{first_name: "First", last_name: "Last", zip_code: 1111, email: "test@email.com",
                             address1: "Some Street", address2: "Some other Street", meal_type_id: @meal_type.id, weekend_delivery_range: "6:30-12:10",
                             delivery_instructions: "Help me", phone: 88888809887, plan_id: 10028, facebook_id: "213123", password: "password",
                             card_cvc: 123, card_number: 4242424242424242, card_exp_month: 12, card_exp_year: 2016, ingredient_ids: [@ingredient.id, @ingredient2.id]}}.to_json
    @wrong_params = {user:{first_name: "First", last_name: "Last", zip_code: "wrong", email: "wroong",
                             address1: "Wrong Street", address2: "Some other wrong Street", meal_type_id: "wrong", weekday_delivery_range: "wrong",
                             delivery_instructions: "Help me i'm wrong", phone: "wrong", plan_id: "wrong", facebook_id: "213123", password: "password",
                             card_cvc: "wrong", card_number: "wrong"}}.to_json

    @wrong_card_params = {user:{first_name: "First", last_name: "Last", zip_code: 1111, email: "test@email.com",
                             address1: "Some Street", address2: "Some other Street", meal_type_id: @meal_type.id, weekend_delivery_range: "6:30-12:10",
                             delivery_instructions: "Help me", phone: 88888809887, plan_id: 10028, facebook_id: "213123", password: "password",
                             card_cvc: "12a", card_number: 4242424242424242, card_exp_month: 12, card_exp_year: 2016, ingredient_ids: [@ingredient.id, @ingredient2.id]}}.to_json

    @headers = { "Accept" => "application/json", "Content-Type" => "application/json" }
  end

  test "should sign up user" do
    assert_difference('User.count', +1) do
      post(api_sign_up_path, @success_params, @headers)
      assert_response :success
      assert_equal JSON.parse(response.body)["success"], 0
      assert JSON.parse(response.body)["result"]["id"].present?
    end
    assert User.find_by(email: "test@email.com").subscription_id.include?("sub_")
    assert User.find_by(email: "test@email.com").customer_id.include?("cus_")
  end

  test "should not sign up user" do
    assert_no_difference('User.count') do
      post(api_sign_up_path, @wrong_params, @headers)
      assert_response :success
      assert_equal JSON.parse(response.body)["success"], 1
      assert_equal JSON.parse(response.body)["message"], "Sorry, wrong parameters"
    end
  end

  test "should not sign up user with wrong card" do
    assert_no_difference('User.count') do
      post(api_sign_up_path, @wrong_card_params, @headers)
      assert_response :success
      assert_equal JSON.parse(response.body)["success"], 1
      assert_equal JSON.parse(response.body)["message"], "402 - Payment Required"
    end
  end
end
