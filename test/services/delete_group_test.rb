require 'test_helper'


class DeleteGroupTest < ActiveSupport::TestCase
  setup do
    @categories_group = create(:categories_group)
    @categories_group2 = create(:categories_group)

    @category = create(:ingredient_category, categories_group_id: @categories_group.id)
    @category2 = create(:ingredient_category, categories_group_id: @categories_group.id)
    @category3 = create(:ingredient_category)
  end

  test "should success" do
    assert_difference('CategoriesGroup.count', -1) do
      service = DeleteGroup.call(group_id: @categories_group.id)
      assert service.success
      assert_equal IngredientCategory.where(categories_group_id: @categories_group.id).count, 0
    end
  end

  test "should fail with empty params" do
    assert_no_difference('CategoriesGroup.count', -1) do
      service = DeleteGroup.call(group_id: "")
      assert_not service.success
    end
  end
end
