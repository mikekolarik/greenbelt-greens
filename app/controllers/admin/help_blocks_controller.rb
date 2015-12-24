class Admin::HelpBlocksController < Admin::ApplicationController

  def new
    @help_block = HelpBlock.new
  end

  def index
    @help_blocks = HelpBlock.all.page(params[:page])
  end

  def show
    @help_block = HelpBlock.find(params[:id])
  end

  def create
    @help_block = HelpBlock.new(permitted_params[:help_block])
      if @help_block.save
        redirect_to admin_help_blocks_path, notice: "Success"
      else
        flash[:notice] = "Try Again"
        render 'new'
      end
  end

  def update
    @help_block = HelpBlock.find(params[:id])
    if @help_block.update_attributes(permitted_params[:help_block])
      redirect_to admin_help_blocks_path, notice: "Successfully updated"
    end
  end

  def destroy
    @help_block = HelpBlock.find(params[:id])
    @help_block.destroy
    redirect_to admin_help_blocks_path, notice: "Successfully deleted"
  end


  private

  def permitted_params
      { help_block:
          params.fetch(:help_block, {}).permit(:key, :description) }
  end
end
