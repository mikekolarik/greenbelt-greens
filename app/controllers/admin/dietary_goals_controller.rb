class Admin::DietaryGoalsController < Admin::ApplicationController

  def new
    @dietary_goal = DietaryGoal.new
  end

  def index
    @dietary_goals = DietaryGoal.all.page(params[:page])
  end

  def show
    @dietary_goal = DietaryGoal.find(params[:id])
  end

  def create
    @dietary_goal = DietaryGoal.new(permitted_params[:dietary_goal])
    if @dietary_goal.save
      flash[:notice] = "Success"
      redirect_to admin_dietary_goals_path
    else
      flash[:notice] = "Try Again"
      render 'new'
    end
  end

  def update
    @dietary_goal = DietaryGoal.find(params[:id])
    if @dietary_goal.update_attributes(permitted_params[:dietary_goal])
      redirect_to admin_dietary_goals_path
      flash[:notice] = "Successfully updated"
    end
  end

  def destroy
    @dietary_goal = DietaryGoal.find(params[:id])
    @dietary_goal.destroy
    redirect_to admin_dietary_goals_path
  end


  private

  def permitted_params
    { dietary_goal:
        params.fetch(:dietary_goal, {}).permit(:name, :picture, :remove_picture) }
  end

end
