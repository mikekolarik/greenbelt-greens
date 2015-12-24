require 'test_helper'

class AdminUsersStoriesTest < ActionDispatch::IntegrationTest

  setup do
    login
    @regular_user = create(:user)
    @meal_type = MealType.create(key: "test_mt", description: "test meal type", order: 5)
    @ingredient = create(:ingredient)
  end

  test "should create admin user" do
    visit new_admin_user_path
    fill_in 'Email', with: 'uniq@mail.com'
    fill_in 'Password', with: 'password'
    fill_in 'Confirmation', with: 'password'
    click_button 'Create User'
    assert page.has_content? "uniq@mail.com"
    assert_equal User.find_by(email: "uniq@mail.com").admin, true
  end

  test "should list only admin users" do
    visit admin_users_path
    click_link 'Admins'
    assert page.has_no_content? false
    assert page.has_css? (".m-button-submit")
  end

  test "should delete user" do
    visit admin_users_path
    first(:link, "Delete User").click
    assert page.has_no_content? false
    assert page.has_css? (".m-button-submit")
  end

  test "should switch admin user to regular" do
    click_link 'Users'
    assert page.has_content? 'Users'
    assert @user.admin?
    first(:link, "Switch").click
    assert_not @regular_user.admin?
  end

  test "should edit user email" do
    visit admin_users_path
    click_link @regular_user.email
    fill_in @regular_user.email, with: "new.email@mail.com"
    click_button 'Update User'
    assert page.has_content? "User successfully updated"
    assert page.has_content? "new.email@mail.com"
  end

  test "should edit user first name" do
    visit admin_users_path
    click_link @regular_user.email
    fill_in "First Name", with: "Test First Name"
    click_button 'Update User'
    assert page.has_content? "User successfully updated"
    click_link @regular_user.email
    find("input[placeholder='Test First Name']")
  end

  test "should edit user last name" do
    visit admin_users_path
    click_link @regular_user.email
    fill_in "Last Name", with: "Test Last Name"
    click_button 'Update User'
    assert page.has_content? "User successfully updated"
    click_link @regular_user.email
    find("input[placeholder='Test Last Name']")
  end

  test "should edit user password" do
    visit admin_users_path
    click_link @regular_user.email
    old_password = @regular_user.encrypted_password
    fill_in "Password", with: "new_password"
    fill_in "Confirmation", with: "new_password"
    click_button 'Update User'
    assert page.has_content? "User successfully updated"
    assert_not_equal old_password, User.find_by(id: @regular_user.id).encrypted_password
  end

  test "should edit user zip code" do
    visit admin_users_path
    click_link @regular_user.email
    fill_in @regular_user.zip_code, with: 12345
    click_button 'Update User'
    assert page.has_content? "User successfully updated"
    click_link @regular_user.email
    find("input[placeholder='12345']")
  end

  test "should edit user address 1" do
    visit admin_users_path
    click_link @regular_user.email
    fill_in "Address 1", with: "Test Address 1"
    click_button 'Update User'
    assert page.has_content? "User successfully updated"
    click_link @regular_user.email
    find("input[placeholder='Test Address 1']")
  end

  test "should edit user address 2" do
    visit admin_users_path
    click_link @regular_user.email
    fill_in "Address 2", with: "Test Address 2"
    click_button 'Update User'
    assert page.has_content? "User successfully updated"
    click_link @regular_user.email
    find("input[placeholder='Test Address 2']")
  end

  test "should edit user phone" do
    visit admin_users_path
    click_link @regular_user.email
    fill_in "Phone Number", with: '1234567890'
    click_button 'Update User'
    assert page.has_content? "User successfully updated"
    click_link @regular_user.email
    find("input[placeholder='1234567890']")
  end

  test "should edit user delivery instructions" do
    visit admin_users_path
    click_link @regular_user.email
    fill_in "Delivery Instructions", with: "Test Delivery Instructions"
    click_button 'Update User'
    assert page.has_content? "User successfully updated"
    click_link @regular_user.email
    find("input[placeholder='Test Delivery Instructions']")
  end

  test "should edit user meal type" do
    visit admin_users_path
    click_link @regular_user.email
    select "test meal type", :from => "user_meal_type_id"
    click_button 'Update User'
    assert page.has_content? "User successfully updated"
    assert_equal "test meal type", User.find_by(id: @regular_user.id).meal_type.description
  end

  test "should edit user delivery range" do
    visit admin_users_path
    click_link @regular_user.email
    fill_in "Delivery Range", with: "10-30 p.m."
    click_button 'Update User'
    assert page.has_content? "User successfully updated"
    click_link @regular_user.email
    find("input[placeholder='10-30 p.m.']")
  end

  test "should edit user ingredients" do
    visit admin_users_path
    click_link @regular_user.email
    check 'ingredient_ids_'
    click_button 'Update User'
    assert page.has_content? "User successfully updated"
    assert_equal @ingredient.id, User.find_by(id: @regular_user.id).ingredient_ids.first
  end
end
