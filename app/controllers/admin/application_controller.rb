class Admin::ApplicationController < ApplicationController
  layout "admin"

  before_filter :authenticate_user!
  before_filter :redirect_if_not_admin

  def redirect_if_not_admin
    unless current_user.admin? && current_user
      redirect_to not_admin_path
    end
  end
end
