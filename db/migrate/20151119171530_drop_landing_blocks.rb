class DropLandingBlocks < ActiveRecord::Migration
  def change
    drop_table :landing_blocks
  end
end
