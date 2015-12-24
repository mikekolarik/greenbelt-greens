require 'test_helper'

class AdminIngredientsStoriesTest < ActionDispatch::IntegrationTest

  setup do
    login
    @dietary_goal = create(:dietary_goal)
    @dietary_preference = create(:dietary_preference)
    @ingredient_category = IngredientCategory.create(name: "vegetables")
    @ingredient_category2 = IngredientCategory.create(name: "test_category")
    @ingredient = Ingredient.create(name: "orange", ingredient_category_id: @ingredient_category.id)
  end

  test "should create new ingredient" do
    visit new_admin_ingredient_path
    fill_in 'Name', with: 'Uniq'
    click_button 'Create Ingredient'
    assert page.has_content? 'Ingredient was successfully created'
  end

  test "should select category" do
    visit admin_ingredients_path
    click_link(@ingredient.name)
    select "test_category", :from => "ingredient_ingredient_category_id"
    click_button 'Update Ingredient'
    assert page.has_content? 'Ingredient was successfully updated'
  end

  test "should set dietary goal" do
    visit admin_ingredients_path
    click_link(@ingredient.name)
    check "ingredient[dietary_goal_ids][]"
    click_button 'Update Ingredient'
    assert page.has_content? 'Ingredient was successfully updated'
    assert @ingredient.dietary_goals.present?
  end

  test "should set dietary preference" do
    visit admin_ingredients_path
    click_link(@ingredient.name)
    check "ingredient[dietary_preference_ids][]"
    click_button 'Update Ingredient'
    assert page.has_content? 'Ingredient was successfully updated'
    assert @ingredient.dietary_preferences.present?
  end

  test "should not duplicate ingredient name" do
    visit new_admin_ingredient_path
    fill_in 'Name', with: @ingredient.name
    click_button 'Create Ingredient'
    assert page.has_content? 'Name has already been taken'
  end

  test "should list ingredients" do
    visit admin_ingredients_path
    assert page.has_content? @ingredient.name
    find_link('Delete Ingredient', :visible => :all).visible?
    assert page.has_content? 'Ingredients'
    assert page.has_content? 'Name'
    assert page.has_css? (".m-button-submit")
  end

  test "should show new ingredient form" do
    visit new_admin_ingredient_path
    assert page.has_content? 'New Ingredient'
    assert page.has_css? (".m-form-control")
    assert page.has_css? (".m-button-submit")
  end

  test "should edit existed ingredient" do
    visit admin_ingredients_path
    click_link(@ingredient.name)
    assert page.has_content? 'Edit Ingredient'
    fill_in 'Name', with: 'EditedUniq'
    click_button 'Update Ingredient'
    assert page.has_content? 'EditedUniq'
  end

  test "should delete created ingredient" do
    visit admin_ingredients_path
    click_link 'Delete Ingredient'
    assert page.has_no_content? 'Uniq'
    assert page.has_content? 'No Ingredients'
  end

  test "should import ingredients from csv file" do
    visit admin_ingredients_path
    script = "$('.m-import-hidden-button').show();"
    page.execute_script(script)
    attach_file("csv_file_with_ingredient", File.join(Rails.root, "/test/fixtures/files/import_csv_ingredients.csv"))
    click_button 'Import CSV'
    assert page.has_content? "Ingredients successfully imported"
    assert page.has_content? "Corn"
  end

  test "should not import ingredients from wrong csv file" do
    visit admin_ingredients_path
    script = "$('.m-import-hidden-button').show();"
    page.execute_script(script)
    attach_file("csv_file_with_ingredient", File.join(Rails.root, "/test/fixtures/files/wrong_ingredients.csv"))
    click_button 'Import CSV'
    assert page.has_content? "Nothing to import"
  end
end
