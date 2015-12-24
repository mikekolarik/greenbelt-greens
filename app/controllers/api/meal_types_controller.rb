class Api::MealTypesController < ApplicationController
  respond_to :json

  def index
    meal_types = MealType.all

    render json: {
               success: 0,
               result: meal_types
           }

  end
end
