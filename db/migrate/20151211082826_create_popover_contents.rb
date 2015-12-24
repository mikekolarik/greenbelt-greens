class CreatePopoverContents < ActiveRecord::Migration
  def change
    create_table :popover_contents do |t|
      t.string :page_key
      t.text :content
      t.string :picture

      t.timestamps null: false
    end
  end
end
