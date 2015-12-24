class CommonParam < ActiveRecord::Base

  def self.get_param(param)
    (CommonParam.first || CommonParam.new)[param]
  end
end
