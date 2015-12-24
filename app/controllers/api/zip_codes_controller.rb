class Api::ZipCodesController < ApplicationController
  skip_before_filter :verify_authenticity_token,
                    :if => Proc.new { |c| c.request.format == 'application/json' }

  respond_to :json

  def check_for_valid
    service = CheckZipCode.call(permitted_params[:validation][:zip_code])
    if service.zip_code
      render :status => 200,
             :json => { :success => 0 }
    else
      render :status => 200,
             :json => { :success => 1 }
    end
  end

  def permitted_params
    { validation:
        params.fetch(:validation, {}).permit(:zip_code)}
  end
end
