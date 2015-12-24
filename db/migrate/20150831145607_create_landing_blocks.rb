class CreateLandingBlocks < ActiveRecord::Migration
  def change
    create_table :landing_blocks do |t|
      t.string :title
      t.string :description
      t.timestamps
    end
  end
end
