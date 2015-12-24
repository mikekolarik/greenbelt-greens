require "test_helper"

class AdminHelpBlocksStoriesTest < ActionDispatch::IntegrationTest

  setup do
    login
    @help_block = create(:help_block)
  end

  test "should show new help block form" do
    visit new_admin_help_block_path
    assert page.has_content? "New Help Block"
    assert page.has_field? "Key"
    assert page.has_field? "Description"
    assert page.has_css? ".m-button-submit"
  end

  test "should create new help block" do
    visit new_admin_help_block_path
    fill_in "Key", with: @help_block.key
    fill_in "Description", with: @help_block.description
    click_button "Create Help block"
    assert page.has_content? "Success"
  end

  test "shouldn`t take long key and description" do
    visit new_admin_help_block_path
    fill_in "Key", with: @help_block.key * 50
    fill_in "Description", with: @help_block.description * 100
    click_button "Create Help block"
    assert page.has_content? "Key 128 characters is the maximum allowed"
    assert page.has_content? "Description 512 characters is the maximum allowed"
  end

  test "should show list of help blocks" do
    visit admin_help_blocks_path
    assert page.has_content? "Block"
    assert page.has_content? "Help Blocks List"
    assert page.has_content? @help_block.key
    find_link('Delete Block', :visible => :all).visible?
    assert page.has_css? (".m-button-submit")
  end

  test "should edit existed help block" do
    visit admin_help_blocks_path
    click_link @help_block.key
    assert page.has_content? "Edit Help Block"
    fill_in "Key", with: "Editedkey"
    click_button "Update Help block"
    assert page.has_content? "Successfully updated"
    assert page.has_content? "Editedkey"
  end

  test "should delete created help block" do
    visit admin_help_blocks_path
    assert page.has_content? @help_block.key
    click_link "Delete Block"
    assert page.has_no_content? @help_block.key
    assert page.has_content? "No Help Blocks"
  end
end
