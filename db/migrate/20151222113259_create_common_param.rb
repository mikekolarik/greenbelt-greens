class CreateCommonParam < ActiveRecord::Migration
  def up
    CommonParam.create(service_start_date: '2016-01-10')
  end

  def down
    CommonParam.all.destroy_all
  end
end
