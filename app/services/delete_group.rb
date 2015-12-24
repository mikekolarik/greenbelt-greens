class DeleteGroup
  include Concerns::Service
  attr_accessor :success

  def call(group_id:)
    @success = false

    CategoriesGroup.connection.transaction do
      begin
        group = CategoriesGroup.find_by!(id: group_id)
        _clear_relation!(group: group)
        group.destroy!
        @success = true
      rescue ActiveRecord::RecordNotFound, ActiveRecord::RecordInvalid
        raise ActiveRecord::Rollback
      end
    end
  end

  private

  def _clear_relation!(group:)
    group.ingredient_categories.each do |category|
      category.update_attributes!(categories_group_id: nil)
    end
  end
end