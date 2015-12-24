class CreateCommonParams < ActiveRecord::Migration
  def change
    create_table :common_params do |t|
      t.date :service_start_date, default: '2015-12-13'

      t.timestamps null: false
    end
  end
end
