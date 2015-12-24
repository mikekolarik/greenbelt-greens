class Api::SessionsController < Devise::SessionsController

  respond_to :json

  def create
    warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
    render :status => 200,
           :json => { :success => 0,
                      :info => "Logged in",
                      :data => { :auth_token => current_user.authentication_token } }
  end

  def failure
    render :status => 401,
           :json => { :success => 1,
                      :info => "Login Failed",
                      :data => {} }
  end
end
