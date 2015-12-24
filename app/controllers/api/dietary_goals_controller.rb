class Api::DietaryGoalsController < ApplicationController

  respond_to :json

  def index
    dietary_goal = DietaryGoal.all.map {|block| {id: block.id,
                                                 name: block.name,
                                                 picture: block.picture_url}}
    if dietary_goal.present?
      render :json => {:success => 0, :result => dietary_goal}
    else
      render :json => {:success => 1, :message => "Can`t find any dietary goals"}
    end
  end

end
