class Api::MealExamplesController < ApplicationController

  respond_to :json

  def index
    mobile_version = params['mobile'] == 'true'
    meal_examples = MealExample.all.shuffle.take(3).map {
        |me| {user_name: me.user_name, user_avatar: me.user_avatar_url, user_goals: me.user_goals,
              dietary_preferences: me.dietary_preferences,
              meal_photo: mobile_version ? me.meal_photo_url(:thumb_mobile) : me.meal_photo_url,
              meal_ingredients: me.meal_ingredients,
              calories: me.calories, carbs: me.carbs, fat: me.fat, protein: me.protein
      }
    }
    if meal_examples.present?
      render :json => {:success => 0, :result => meal_examples}
    else
      render :json => {:success => 1, :message => "There are no meal examples"}
    end
  end

end
