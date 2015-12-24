require "test_helper"

class AdminIntroScreenBlocksStoriesTest < ActionDispatch::IntegrationTest

  setup do
    login
    @intro_screen_block = create(:intro_screen_block)
  end

  test "should show new intro screen block form" do
    visit new_admin_intro_screen_block_path
    assert page.has_content? "New Intro Screen Block"
    assert page.has_field? "Title"
    assert page.has_field? "Description"
    assert page.has_css? ".m-button-submit"
  end

  test "should create new intro screen block" do
    visit new_admin_intro_screen_block_path
    fill_in "Title", with: @intro_screen_block.title
    fill_in "Description", with: @intro_screen_block.description
    click_button "Create Intro screen block"
    assert page.has_content? "Success"
  end

  test "should not take long title" do
    visit new_admin_intro_screen_block_path
    assert page.has_content? "New Intro Screen Block"
    fill_in "Title", with: @intro_screen_block.title * 50
    fill_in "Description", with: @intro_screen_block.description * 100
    click_button "Create Intro screen block"
    assert page.has_content? "Title 128 characters is the maximum allowed"
    assert page.has_content? "Description 512 characters is the maximum allowed"
  end

  test "should list intro_screen_blocks" do
    visit admin_intro_screen_blocks_path
    assert page.has_content? "Block"
    assert page.has_content? "Blocks List"
    assert page.has_content? @intro_screen_block.title
    find_link('Delete Block', :visible => :all).visible?
    assert page.has_css? (".m-button-submit")
  end

  test "should edit existed intro_screen_block" do
    visit admin_intro_screen_blocks_path
    click_link(@intro_screen_block.title)
    assert page.has_content? "Edit Block"
    fill_in "Title", with: "EditedTitle"
    click_button "Update Intro screen block"
    assert page.has_content? "Successfully updated"
    assert page.has_content? "EditedTitle"
  end

  test "should delete created intro_screen_block" do
    visit admin_intro_screen_blocks_path
    click_link "Delete Block"
    assert page.has_no_content? @intro_screen_block.title
    assert page.has_content? "No Intro Screen Blocks"
  end

  test "should create intro_screen_block with image" do
    visit new_admin_intro_screen_block_path
    fill_in "Title", with: @intro_screen_block.title
    fill_in "Description", with: @intro_screen_block.description
    attach_file("intro_screen_block_picture", File.join(Rails.root, "/test/fixtures/files/intro_screen_block_salad.png"))
    click_button "Create Intro screen block"
    assert page.has_content? "Success"
    assert page.has_css?(".m-landing-icon")
  end

  test "should update intro_screen_block with image" do
    visit admin_intro_screen_blocks_path
    click_link(@intro_screen_block.title)
    attach_file("intro_screen_block_picture", File.join(Rails.root, "/test/fixtures/files/intro_screen_block_salad.png"))
    click_button "Update Intro screen block"
    assert page.has_content? "Successfully updated"
    assert page.has_css?(".m-landing-icon")
  end

  test "should remove intro_screen_block icon" do
    visit admin_intro_screen_blocks_path
    click_link(@intro_screen_block.title)
    check "intro_screen_block_remove_picture"
    click_button "Update Intro screen block"
    assert page.has_content? "Successfully updated"
    assert page.has_no_css?(".m-landing-icon")
  end
end
