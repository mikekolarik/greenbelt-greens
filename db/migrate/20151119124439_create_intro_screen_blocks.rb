class CreateIntroScreenBlocks < ActiveRecord::Migration
  def change
    create_table :intro_screen_blocks do |t|
      t.string :title
      t.string :description
      t.timestamps
    end
  end
end
