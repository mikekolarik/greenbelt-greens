class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  after_filter :cors_set_access_control_headers
  skip_before_filter :verify_authenticity_token, only: [:handle_options_request]

  def handle_options_request
    head :ok if request.request_method == 'OPTIONS'
  end

  def cors_set_access_control_headers
    tmp_origin = request.headers['origin']
    if %w(http://localhost:3000 http://mealticket.agilie.com http://greenbeltgreens.com).include?(tmp_origin)
      headers['Access-Control-Allow-Origin'] = tmp_origin
    end

    headers['Access-Control-Allow-Methods'] = %w{GET POST PUT DELETE PATCH HEAD OPTIONS}.join(',')
    headers['Access-Control-Allow-Headers'] = 'Content-Type,auth_token'
    headers['Access-Control-Max-Age'] = '1728000'
  end

  private

  def after_sign_in_path_for(resource_or_scope)
    admin_intro_screen_blocks_path
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end
