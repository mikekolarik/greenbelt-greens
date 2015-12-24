require 'test_helper'

class AdminDietaryGoalsStoriesTest < ActionDispatch::IntegrationTest

  setup do
    login
    @dietary_goal = create(:dietary_goal)
  end

  test "shouldn`t create dietary goal without picture" do
    visit new_admin_dietary_goal_path
    fill_in 'Name', with: 'Uniq'
    click_button 'Create Dietary goal'
    assert page.has_content? "Picture can't be blank"
  end

  test "should not duplicate dietary goal name" do
    visit new_admin_dietary_goal_path
    fill_in 'Name', with: @dietary_goal.name
    click_button 'Create Dietary goal'
    assert page.has_content? 'Name has already been taken'
  end

  test "should list dietary goals" do
    visit admin_dietary_goals_path
    assert page.has_content? @dietary_goal.name
    assert page.has_content? 'Dietary Goals'
    assert page.has_content? 'Name'
    find_link('Delete Goal', :visible => :all).visible?
    assert page.has_css? (".m-button-submit")
  end

  test "should edit existed dietary goal" do
    visit admin_dietary_goals_path
    click_link(@dietary_goal.name)
    assert page.has_content? 'Edit Goal'
    fill_in 'Name', with: 'EditedUniq'
    click_button 'Update Dietary goal'
    assert page.has_content? 'EditedUniq'
    assert page.has_content? 'Successfully updated'
  end

  test "should delete created dietary goal" do
    visit admin_dietary_goals_path
    click_link 'Delete Goal'
    assert page.has_no_content? 'Uniq'
    assert page.has_content? 'No Goals'
  end

  test "should create dietary goal with picture" do
    visit new_admin_dietary_goal_path
    assert page.has_content? 'New Goal'
    fill_in 'Name', with: 'Uniq'
    attach_file("dietary_goal_picture", File.join(Rails.root, "/test/fixtures/files/goal.svg"))
    click_button 'Create Dietary goal'
    assert page.has_content? 'Success'
  end

  test "should update dietary goal with picture" do
    visit admin_dietary_goals_path
    click_link(@dietary_goal.name)
    assert page.has_content? "Edit Goal"
    attach_file("dietary_goal_picture", File.join(Rails.root, "/test/fixtures/files/goal.svg"))
    click_button 'Update Dietary goal'
    assert page.has_content? "Successfully updated"
    assert page.has_css?(".m-icon-list")
  end

  test "should remove dietary goal picture" do
    visit admin_dietary_goals_path
    click_link(@dietary_goal.name)
    check "dietary_goal_remove_picture"
    click_button 'Update Dietary goal'
    assert page.has_content? "Successfully updated"
    assert page.has_no_css?(".m-icon-list")
  end
end
