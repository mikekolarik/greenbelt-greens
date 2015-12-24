require "test_helper"

class AdminMealExamplesStoriesTest < ActionDispatch::IntegrationTest

  setup do
    login
    @meal_example = create(:meal_example)
    @dietary_goal = create(:dietary_goal)
  end

  test "should create new meal example" do
    visit new_admin_meal_example_path
    assert page.has_content? "New Meal Example"
    fill_in "User Name", with: "NewUserName"
    attach_file("meal_example_user_avatar", File.join(Rails.root, "/test/fixtures/files/avatar1.png"))
    attach_file("meal_example_meal_photo", File.join(Rails.root, "/test/fixtures/files/intro_screen_block_salad.png"))
    fill_in "Meal Ingredients", with: "Chiken, Mushrooms, Onion, Cheese"
    check("meal_example_user_goals_#{@dietary_goal.name.underscore.gsub(" ","_")}")
    click_button "Create Meal example"
    assert page.has_content? "Success"
  end

  test "should not create new meal example" do
    visit new_admin_meal_example_path
    click_button "Create Meal example"
    assert page.has_content? "Try Again"
    assert page.has_content? "5 errors"
  end

  test "should show meal example's list " do
    visit admin_meal_examples_path
    assert page.has_content? "Meal Examples"
    assert page.has_content? "User Name"
    assert page.has_content? @meal_example.user_name
    assert page.has_content? "Delete"
    assert page.has_css? (".m-button-submit")
    assert page.has_css? (".m-admin-button")
  end

  test "should edit existed intro_screen_block" do
    visit admin_meal_example_path(@meal_example)
    assert page.has_content? "Edit Meal Example"
    assert page.has_css? (".m-meal-example-meal-photo")
    assert page.has_css? (".m-meal-example-user-avatar")
    fill_in "User Name", with: "ChangedUserName"
    click_button "Update Meal example"
    assert page.has_content? "Successfully updated"
    assert page.has_content? "ChangedUserName"
  end

  test "should delete meal_example" do
    visit admin_meal_examples_path
    assert page.has_content? @meal_example.user_name
    click_link "Delete"
    assert page.has_no_content? @meal_example.user_name
    assert page.has_content? "No Meal Examples"
  end
end
