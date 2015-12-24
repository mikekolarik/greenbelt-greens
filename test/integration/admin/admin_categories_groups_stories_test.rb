require 'test_helper'

class CategoriesGroupsStoriesTest < ActionDispatch::IntegrationTest

  setup do
    login
    @categories_group = create(:categories_group)
    @categories_group2 = create(:categories_group)

    @category = create(:ingredient_category, categories_group_id: @categories_group.id)
    @category2 = create(:ingredient_category, categories_group_id: @categories_group.id)
    @category3 = create(:ingredient_category)
  end

  test "shouldn`t create category_group without name" do
    visit new_admin_categories_group_path
    fill_in 'Name', with: ''
    click_button 'Create Categories group'
    assert page.has_content? "Name can't be blank"
  end

  test "should create category_group" do
    visit new_admin_categories_group_path
    fill_in 'Name', with: 'Some Name'
    click_button 'Create Categories group'
    assert page.has_content? 'Group was successfully created'
  end

  test "should not create with same category_group name" do
    visit new_admin_categories_group_path
    fill_in 'Name', with: @categories_group.name
    click_button 'Create Categories group'
    assert page.has_content? 'Name has already been taken'
  end

  test "should list category_groups" do
    visit admin_categories_groups_path
    assert page.has_content? @categories_group.name
    assert page.has_content? 'Categories Groups'
    assert page.has_content? 'Name'
    assert page.has_css? (".m-button-submit")
  end

  test "should edit existed category_group" do
    visit admin_categories_groups_path
    click_link(@categories_group.name)
    assert page.has_content? 'Edit Group Of Ingredient Categories'
    fill_in 'Name', with: 'Some Name2'
    click_button 'Update Categories group'
    assert page.has_content? 'Some Name2'
    assert page.has_content? 'Group was successfully updated'
  end

  test "should delete created category_group" do
    visit admin_categories_groups_path
    first(:link, 'Delete Group').click
    first(:link, 'Delete Group').click
    assert page.has_content? 'No Groups Of Ingredient Categories'
  end

  test "should remove one category from group" do
    assert_equal IngredientCategory.where(categories_group_id: @categories_group.id).count, 2
    assert @categories_group.ingredient_categories.count == 2
    visit admin_categories_groups_path
    click_link(@categories_group.name)
    assert page.has_content? 'Edit Group Of Ingredient Categories'
    uncheck("group_categories_ids_", match: :first)
    assert page.has_content? @category.name
    assert page.has_content? @category2.name
    click_button 'Update Categories group'
    assert page.has_content? 'Group was successfully updated'
    assert_equal IngredientCategory.where(categories_group_id: @categories_group.id).count, 1
  end

  test "should add one category to group" do
    assert @categories_group.ingredient_categories.count == 2
    visit admin_categories_groups_path
    click_link(@categories_group.name)
    assert page.has_content? 'Edit Group Of Ingredient Categories'
    check("categories_ids_", match: :first)
    assert page.has_content? @category3.name
    click_button 'Update Categories group'
    assert page.has_content? 'Group was successfully updated'
    assert @categories_group.ingredient_categories.count == 3
  end
end
