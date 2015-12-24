require "test_helper"

class AdminMealTypesStoriesTest < ActionDispatch::IntegrationTest

  setup do
    login
    @meal_type = create(:meal_type)
  end

  test "should show new meal type form" do
    visit new_admin_meal_type_path
    assert page.has_content? "New Meal Type"
    assert page.has_field? "Key"
    assert page.has_field? "Description"
    assert page.has_css? ".m-button-submit"
  end

  test "should create new meal type" do
    visit new_admin_meal_type_path
    fill_in "Key", with: @meal_type.key
    fill_in "Description", with: @meal_type.description
    click_button "Create Meal type"
    assert page.has_content? "Success"
  end

  test "shouldn`t take long key and description" do
    visit new_admin_meal_type_path
    fill_in "Key", with: @meal_type.key * 50
    fill_in "Description", with: @meal_type.description * 100
    click_button "Create Meal type"
    assert page.has_content? "Key 128 characters is the maximum allowed"
    assert page.has_content? "Description 512 characters is the maximum allowed"
  end

  test "should show list of meal types" do
    visit admin_meal_types_path
    assert page.has_content? "Meal"
    assert page.has_content? "Meal Types List"
    assert page.has_content? @meal_type.key
    find_link('Delete Type', :visible => :all).visible?
    assert page.has_css? (".m-button-submit")
  end

  test "should edit existed meal type" do
    visit admin_meal_types_path
    click_link @meal_type.key
    assert page.has_content? "Edit Meal Type"
    fill_in "Key", with: "Editedkey"
    click_button "Update Meal type"
    assert page.has_content? "Successfully updated"
    assert page.has_content? "Editedkey"
  end

  test "should delete created meal type" do
    visit admin_meal_types_path
    assert page.has_content? @meal_type.key
    click_link "Delete Type"
    assert page.has_no_content? @meal_type.key
    assert page.has_content? "No Meal Types"
  end
end
