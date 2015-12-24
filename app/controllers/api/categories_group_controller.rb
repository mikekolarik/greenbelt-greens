class Api::CategoriesGroupController < ApplicationController
  respond_to :json

  ##
  # get all ingredients
  #
  # === Request params:
  # * URL: /api/categories_groups/full_data
  # * Type: GET
  # * Content-Type: application/json
  #
  # === Request (json):
  #
  # === Response (json):
  # {"success":0,"result":[{"id":1,"title":"Group category 1","ingredient_categories":[{"id":1,"title":"IngredientCategory 1","ingredients":[{"id":3,"title":"Name 3"}]},{"id":2,"title":"IngredientCategory 2","ingredients":[]}]},{"id":2,"title":"Group category 2","ingredient_categories":[{"id":3,"title":"IngredientCategory 3","ingredients":[{"id":2,"title":"test 2"}]}]}]}

  def get_full_data
    categories_group_arr = CategoriesGroup.includes(:ingredient_categories).all.map do |cur_cg|
      elem = {:id => cur_cg.id, :title => cur_cg.name, :order_index => cur_cg.order_index, :ingredient_categories => []}
      elem[:ingredient_categories] = cur_cg.ingredient_categories.map do |cur_ic|
        cur_ic_elem = {:id => cur_ic.id, :title => cur_ic.name, :ingredients => []}
        cur_ic_elem[:ingredients] = cur_ic.ingredients.map { |cur_i|
          {
              :id => cur_i.id,
              :title => cur_i.name,
              :dietary_goals => cur_i.dietary_goals.map { |cur_dg| {:id => cur_dg.id, :title => cur_dg.name} },
              :dietary_preferences => cur_i.dietary_preferences.map { |cur_dp| {:id => cur_dp.id, :title => cur_dp.name} }
          }
        }
        cur_ic_elem
      end
      elem
    end

    render :json => {:success => 0, :result => categories_group_arr }
  end
end