class AddIconToLandingBlocks < ActiveRecord::Migration
  def change
    add_column :landing_blocks, :icon, :string
  end
end
