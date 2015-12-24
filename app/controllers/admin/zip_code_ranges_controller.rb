class Admin::ZipCodeRangesController < Admin::ApplicationController

  def index
    @zip_code_ranges = ZipCodeRange.all.page(params[:page])
  end

  def show
    @zip_code_range = ZipCodeRange.find(params[:id])
  end

  def new
    @zip_code_range = ZipCodeRange.new
  end

  def create
    @zip_code_range = ZipCodeRange.new(permitted_params[:zip_code_range])
    if @zip_code_range.save
      flash[:notice] = "Success"
      redirect_to admin_zip_code_ranges_path
    else
      flash[:notice] = "Try Again"
      render 'new'
    end
  end

  def update
    @zip_code_range = ZipCodeRange.find(params[:id])
    if @zip_code_range.update_attributes(permitted_params[:zip_code_range])
      flash[:notice] = "Success"
      redirect_to admin_zip_code_ranges_path
    else
      flash[:notice] = "Try Again"
      render 'show'
    end
  end

  def destroy
    @zip_code_range = ZipCodeRange.find(params[:id])
    @zip_code_range.destroy
    flash[:notice] = "Success"
    redirect_to admin_zip_code_ranges_path
  end

  private

  def permitted_params
    { zip_code_range:
        params.fetch(:zip_code_range, {}).permit(:zip_from, :zip_to) }
  end
end
