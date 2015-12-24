class Admin::PopoverContentsController < Admin::ApplicationController

  def new
    @intro_screen_block = PopoverContent.new
  end

  def index
    @intro_screen_blocks = PopoverContent.all.page(params[:page])
  end

  def show
    @intro_screen_block = PopoverContent.find(params[:id])
  end

  def create
    @intro_screen_block = PopoverContent.new(permitted_params[:popover_content])
      if @intro_screen_block.save
        redirect_to admin_popover_contents_path, notice: "Success"
      else
        flash[:notice] = "Try Again"
        render 'new'
      end
  end

  def update
    @intro_screen_block = PopoverContent.find(params[:id])
    if @intro_screen_block.update_attributes(permitted_params[:popover_content])
      redirect_to admin_popover_contents_path, notice: "Successfully updated"
    end
  end

  def destroy
    @intro_screen_block = PopoverContent.find(params[:id])
    @intro_screen_block.destroy
    redirect_to admin_popover_contents_path, notice: "Successfully deleted"
  end


  private

  def permitted_params
      { popover_content:
          params.fetch(:popover_content, {}).permit(:content, :picture, :remove_picture, :order_index, :header, :sub_header) }
  end
end
