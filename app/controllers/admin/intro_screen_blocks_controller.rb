class Admin::IntroScreenBlocksController < Admin::ApplicationController

  def new
    @intro_screen_block = IntroScreenBlock.new
  end

  def index
    @intro_screen_blocks = IntroScreenBlock.all.page(params[:page])
  end

  def show
    @intro_screen_block = IntroScreenBlock.find(params[:id])
  end

  def create
    @intro_screen_block = IntroScreenBlock.new(permitted_params[:intro_screen_block])
      if @intro_screen_block.save
        redirect_to admin_intro_screen_blocks_path, notice: "Success"
      else
        flash[:notice] = "Try Again"
        render 'new'
      end
  end

  def update
    @intro_screen_block = IntroScreenBlock.find(params[:id])
    if @intro_screen_block.update_attributes(permitted_params[:intro_screen_block])
      redirect_to admin_intro_screen_blocks_path, notice: "Successfully updated"
    end
  end

  def destroy
    @intro_screen_block = IntroScreenBlock.find(params[:id])
    @intro_screen_block.destroy
    redirect_to admin_intro_screen_blocks_path, notice: "Successfully deleted"
  end


  private

  def permitted_params
      { intro_screen_block:
          params.fetch(:intro_screen_block, {}).permit(:title, :description, :picture, :remove_picture, :order_index) }
  end
end
