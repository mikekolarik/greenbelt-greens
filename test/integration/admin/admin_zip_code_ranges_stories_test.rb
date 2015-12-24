require 'test_helper'

class AdminZipCodeRangesStoriesTest < ActionDispatch::IntegrationTest

  setup do
    login
    @zip_code_range = create(:zip_code_range)
  end

  test "should create new range" do
    visit new_admin_zip_code_range_path
    assert page.has_content? 'New Range'
    fill_in 'From', with: 1100
    fill_in 'To', with: 1200
    click_button 'Create Zip code range'
    assert page.has_content? 'Success'
  end

  test "should list ranges" do
    visit admin_zip_code_ranges_path
    assert page.has_content? @zip_code_range.zip_from
    assert page.has_content? @zip_code_range.zip_to
    find_link('Delete Range', :visible => :all).visible?
    assert page.has_css? (".m-button-submit")
  end

  test "should show new range form" do
    visit new_admin_zip_code_range_path
    assert page.has_content? 'New Range'
    assert page.has_css? (".m-form-control")
    assert page.has_css? (".m-button-submit")
  end

  test "should edit existed zip code range" do
    visit admin_zip_code_ranges_path
    click_link(@zip_code_range.zip_from)
    assert page.has_content? 'Edit Range'
    fill_in 'From', with: 1200
    fill_in 'To', with: 1500
    click_button 'Update Zip code range'
    assert page.has_content? 'Success'
  end

  test "should delete created zip code range" do
    visit admin_zip_code_ranges_path
    click_link 'Delete Range'
    assert page.has_no_content? "1000"
    assert page.has_content? 'No Ranges'
  end
end
