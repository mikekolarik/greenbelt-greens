class Api::IngredientsController < ApplicationController
  respond_to :json

  ##
  # get all ingredients
  #
  # === Request params:
  # * URL: /api/ingredients
  # * Type: GET
  # * Content-Type: application/json
  #
  # === Request (json):
  #
  # === Response (json):
  #
  # {
  #   "success":0,
  #   "result":
  #     [
  #       {
  #         "id":1,
  #         "title":"Test 1",
  #         "category":null,
  #         "goals":[{"id":1,"title":"High protein"},{"id":3,"title":"Low calories"},{"id":6,"title":"Macro based"}],
  #         "preferences":[{"id":1,"title":"I`ll eat it all!"},{"id":3,"title":"Dairy Free"},{"id":5,"title":"Vegan"},{"id":6,"title":"Gluten Free"}]
  #       },
  #       {"id":2,"title":"test 2","category":{"id":3,"title":"IngredientCategory 3","category_group":null},"goals":[{"id":3,"title":"Low calories"},{"id":6,"title":"Macro based"}],"preferences":[{"id":2,"title":"Vegetarian"},{"id":5,"title":"Vegan"}]},{"id":3,"title":"Name 3","category":{"id":1,"title":"IngredientCategory 1","category_group":null},"goals":[{"id":5,"title":"Low sugar"},{"id":6,"title":"Macro based"}],"preferences":[{"id":1,"title":"I`ll eat it all!"},{"id":2,"title":"Vegetarian"}]}
  #     ]
  # }


  def index
    ingredient_arr = Ingredient.includes(:ingredient_category, :dietary_goals, :dietary_preferences).all.map do |cur_ing|
      elem = {:id => cur_ing.id, :title => cur_ing.name, :category => nil}
      unless cur_ing.ingredient_category.blank?
        elem[:category] = {:id => cur_ing.ingredient_category.id, :title => cur_ing.ingredient_category.name, :category_group => nil}
        elem[:category][:category_group] = {:id => cur_ing.ingredient_category.categories_group.id, :title => cur_ing.ingredient_category.categories_group.name} unless cur_ing.ingredient_category.categories_group.blank?
      end
      elem[:goals] = cur_ing.dietary_goals.map { |cur_dg| {:id => cur_dg.id, :title => cur_dg.name} }
      elem[:preferences] = cur_ing.dietary_preferences.map { |cur_dp| {:id => cur_dp.id, :title => cur_dp.name} }
      elem
    end
    render :json => {:success => 0, :result => ingredient_arr }
  end
end