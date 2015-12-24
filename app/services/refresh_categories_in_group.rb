class RefreshCategoriesInGroup
  include Concerns::Service
  attr_accessor :success

  def call(group:, categories_ids: [], group_categories_ids: [])
    @success = false

    IngredientCategory.connection.transaction do
      begin
        if CategoriesGroup.find_by!(id: group)
          _remove_category_from_group!(group: group, categories: group_categories_ids)
          _add_category_to_group!(group: group, categories: categories_ids)
          @success = true
        end
      rescue ActiveRecord::RecordNotFound, ActiveRecord::RecordInvalid
        raise ActiveRecord::Rollback
      end
    end
  end

  private

  def _add_category_to_group!(group:, categories: [])
    unless categories.blank? || categories == nil
      categories.each do |category_id|
        IngredientCategory.find_by_id(category_id).update_attributes!(categories_group_id: group.id)
      end
    end
  end

  def _remove_category_from_group!(group:, categories: [])
    if group.ingredient_categories.count != 0 && categories != nil
      group.ingredient_categories.each do |category|
        unless categories == nil
          if categories.index(category.id.to_s) == nil
            IngredientCategory.find_by_id(category.id).update_attributes!(categories_group_id: nil)
          end
        else
          IngredientCategory.find_by_id(category.id).update_attributes!(categories_group_id: nil)
        end
      end
    end
  end
end