class CreateHelpBlocks < ActiveRecord::Migration
  def change
    create_table :help_blocks do |t|
      t.string :key
      t.text :description

      t.timestamps null: false
    end
  end
end
