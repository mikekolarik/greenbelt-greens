class AddIntroScreenPictureToIntroScreenBlocks < ActiveRecord::Migration
  def change
    add_column :intro_screen_blocks, :picture, :string
  end
end
