require 'test_helper'


class CreateUserTest < ActiveSupport::TestCase
  setup do
    @meal_type = create(:meal_type)
    @zip_code_range = create(:zip_code_range)
    @ingredient_category = create(:ingredient_category)
    @ingredient = create(:ingredient, ingredient_category: @ingredient_category)
    @ingredient2 = create(:ingredient, ingredient_category: @ingredient_category)
    @success_user_params = {first_name: "First", last_name: "Last", zip_code: 1111, email: "some@email.com",
                            address1: "Some Street", address2: "Some other Street", meal_type_id: @meal_type.id, weekend_delivery_range: "6:30-12:10",
                            delivery_instructions: "Help me", phone: 8888098870, plan_id: 10028, facebook_id: "213123", password: "password", ingredient_ids: [@ingredient.id, @ingredient2.id]}
    @wrong_user_params = {first_name: "wrong", last_name: "wrong", zip_code: 1111, email: "wrong",
                          address1: "wrong", address2: "wrong", meal_type_id: @meal_type.id, weekday_delivery_range: "6:30-12:10",
                          delivery_instructions: "Help me", phone: 888888881288, plan_id: 10027, facebook_id: "213123", password: "password", ingredient_ids: [@ingredient.id, @ingredient2.id]}
    @success_card_params = {card_cvc: 123, card_number: 4242424242424242, card_exp_month: 12, card_exp_year: 2016}
    @wrong_card_params = {card_cvc: "12a", card_number: 4242424242424242, card_exp_month: 12, card_exp_year: 2011}
  end

  test "should success" do
    service = CreateUser.call(user_params: @success_user_params, card_params: @success_card_params)
    assert service.success
    assert User.find(service.user.id)
    assert_equal service.user.first_name, "First"
    assert_equal service.user.last_name, "Last"
    assert_equal service.user.email, "some@email.com"
    assert service.user.subscription_id.include?("sub_")
    assert service.user.customer_id.include?("cus_")
    assert_equal service.user.ingredients.count, 2
  end

  test "should fail with empty params" do
    assert_no_difference('User.count') do
      service = CreateUser.call(user_params: "", card_params: "")
      assert_not service.success
    end
  end

  test "should fail with wrong params" do
    assert_no_difference('User.count') do
      service = CreateUser.call(user_params: {}, card_params: {})
      assert_not service.success
    end
  end

  test "should fail with wrong card_params" do
    assert_no_difference('User.count') do
      service = CreateUser.call(user_params: @success_user_params, card_params: @wrong_card_params)
      assert_not service.success
      assert_equal service.stripe_message, "402 - Payment Required"
    end
  end

  test "should fail with empty card_params" do
    assert_no_difference('User.count') do
      service = CreateUser.call(user_params: @success_user_params, card_params: {})
      assert_not service.success
      assert_equal service.stripe_message, "402 - Payment Required"
    end
  end
end
