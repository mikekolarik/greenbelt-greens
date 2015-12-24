class Api::RegistrationsController < Devise::RegistrationsController
  skip_before_filter :verify_authenticity_token,
                    :if => Proc.new { |c| c.request.format == 'application/json' }

  respond_to :json

  def create
    user = User.new(sign_up_params)
    user.save
    if user.persisted?
      render :status => 200,
             :json => { :success => 0,
                        :info => "Registered",
                        :data => { :auth_token => user.authentication_token } }
    else
      render :status => :unprocessable_entity,
             :json => { :success => 1,
                        :info => user.errors,
                        :data => {} }
    end
  end

  def get_first_delivery_date
    current_day = Date::ABBR_DAYNAMES[Date.today.wday]
    date_to_put = 'Sunday'
    next_week_days = %w(Thu Fri Sat)

    if Date.today < CommonParam.get_param('service_start_date')
      return_date = '2016-01-10'
    else
      return_date = Date.parse(date_to_put) + 7.days
      return_date += 7.days if next_week_days.include? current_day
    end

    render json: {
               success: 0,
               result: {
                   first_delivery_date: return_date
               }
           }
  end
end
