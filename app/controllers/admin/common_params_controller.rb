class Admin::CommonParamsController < Admin::ApplicationController

  def index
    @common_param = CommonParam.first
  end

  def update
    @common_param = CommonParam.first
    if @common_param.update_attributes(permitted_params[:common_param])
      redirect_to admin_common_params_path, notice: "Successfully updated"
    end
  end

  private

  def permitted_params
    { common_param:
          params.fetch(:common_param, {}).permit(:discount_value) }
  end
end
