require 'test_helper'

class AdminIngredientCategoriesStoriesTest < ActionDispatch::IntegrationTest

  setup do
    login
    @ingredient_category = IngredientCategory.create(name: "vegetables")
  end

  test "should create new ingredient_category" do
    visit new_admin_ingredient_category_path
    assert page.has_content? 'New Ingredient Category'
    fill_in 'Name', with: 'Uniq'
    click_button 'Create Ingredient category'
    assert page.has_content? 'Category was successfully created'
  end

  test "should not duplicate ingredient_category name" do
    visit new_admin_ingredient_category_path
    fill_in 'Name', with: @ingredient_category.name
    click_button 'Create Ingredient category'
    assert page.has_content? 'Name has already been taken'
  end

  test "should list ingredient_categories" do
    visit admin_ingredient_categories_path
    assert page.has_content? @ingredient_category.name
    assert page.has_content? 'Delete Category'
    assert page.has_content? 'Ingredient Categories'
    assert page.has_content? 'Name'
    assert page.has_css? (".m-button-submit")
  end

  test "should show new ingredient_category form" do
    visit new_admin_ingredient_category_path
    assert page.has_content? 'New Ingredient Category'
    assert page.has_css? (".m-form-control")
    assert page.has_css? (".m-button-submit")
  end

  test "should edit existed ingredient_category" do
    visit admin_ingredient_categories_path
    click_link(@ingredient_category.name)
    assert page.has_content? 'Edit Ingredient Category'
    fill_in 'Name', with: 'EditedUniq'
    click_button 'Update Ingredient category'
    assert page.has_content? 'EditedUniq'
  end

  test "should delete created ingredient_category" do
    visit admin_ingredient_categories_path
    click_link 'Delete Category'
    assert page.has_no_content? 'Uniq'
    assert page.has_content? 'Category was successfully deleted'
    assert page.has_content? "No Ingredient Categories"
  end

  test "should import ingredient_categories from csv file" do
    visit admin_ingredient_categories_path
    script = "$('.m-import-hidden-button').show();"
    page.execute_script(script)
    attach_file("csv_file_with_ingredient_category", File.join(Rails.root, "/test/fixtures/files/import_csv_ingredient_categories.csv"))
    click_button 'Import CSV'
    assert page.has_content? "Ingredient Categories was successfully imported"
    assert page.has_content? "vegetables"
  end

  test "should not import ingredient_categories from wrong csv file" do
    visit admin_ingredient_categories_path
    script = "$('.m-import-hidden-button').show();"
    page.execute_script(script)
    attach_file("csv_file_with_ingredient_category", File.join(Rails.root, "/test/fixtures/files/wrong_ingredient_categories.csv"))
    click_button 'Import CSV'
    assert page.has_content? "Nothing to import"
  end
end
