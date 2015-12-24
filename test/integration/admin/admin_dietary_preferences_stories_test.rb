require 'test_helper'

class AdminDietaryPreferencesStoriesTest < ActionDispatch::IntegrationTest

  setup do
    login
    @dietary_preference = create(:dietary_preference)
  end

  test "shouldn`t create dietary preference without picture" do
    visit new_admin_dietary_preference_path
    fill_in 'Name', with: 'Uniq'
    click_button 'Create Dietary preference'
    assert page.has_content? "Picture can't be blank"
  end

  test "should not duplicate dietary preference name" do
    visit new_admin_dietary_preference_path
    fill_in 'Name', with: @dietary_preference.name
    click_button 'Create Dietary preference'
    assert page.has_content? 'Name has already been taken'
  end

  test "should list dietary preferences" do
    visit admin_dietary_preferences_path
    assert page.has_content? @dietary_preference.name
    assert page.has_content? 'Dietary Preferences'
    assert page.has_content? 'Name'
    find_link('Delete Preference', :visible => :all).visible?
    assert page.has_css? (".m-button-submit")
  end

  test "should edit existed dietary preference" do
    visit admin_dietary_preferences_path
    click_link(@dietary_preference.name)
    assert page.has_content? 'Edit Preference'
    fill_in 'Name', with: 'EditedUniq'
    click_button 'Update Dietary preference'
    assert page.has_content? 'EditedUniq'
    assert page.has_content? 'Successfully updated'
  end

  test "should delete created dietary preference" do
    visit admin_dietary_preferences_path
    click_link 'Delete Preference'
    assert page.has_no_content? 'Uniq'
    assert page.has_content? 'No Preferences'
  end

  test "should create dietary preference with picture" do
    visit new_admin_dietary_preference_path
    assert page.has_content? 'New Preference'
    fill_in 'Name', with: 'Uniq'
    attach_file("dietary_preference_picture", File.join(Rails.root, "/test/fixtures/files/preference.svg"))
    click_button 'Create Dietary preference'
    assert page.has_content? 'Success'
  end

  test "should update dietary preference with picture" do
    visit admin_dietary_preferences_path
    click_link(@dietary_preference.name)
    assert page.has_content? "Edit Preference"
    attach_file("dietary_preference_picture", File.join(Rails.root, "/test/fixtures/files/preference.svg"))
    click_button 'Update Dietary preference'
    assert page.has_content? "Successfully updated"
    assert page.has_css?(".m-icon-list")
  end

  test "should remove dietary preference picture" do
    visit admin_dietary_preferences_path
    click_link(@dietary_preference.name)
    check "dietary_preference_remove_picture"
    click_button 'Update Dietary preference'
    assert page.has_content? "Successfully updated"
    assert page.has_no_css?(".m-icon-list")
  end
end
