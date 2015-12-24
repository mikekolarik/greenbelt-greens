require 'test_helper'


class RefreshCategoriesInGroupTest < ActiveSupport::TestCase
  setup do
    @group = create(:categories_group)

    @category = create(:ingredient_category, categories_group_id: @group.id)
    @category2 = create(:ingredient_category, categories_group_id: @group.id)
    @category3 = create(:ingredient_category)
    @category4 = create(:ingredient_category)
    @category5 = create(:ingredient_category)

    @categories_ids = [@category3.id.to_s, @category4.id.to_s, @category5.id.to_s]
    @group_categories_ids = [@category.id.to_s, @category2.id.to_s]
  end

  test "should success" do
    service =  RefreshCategoriesInGroup.call(group: @group,
                                             categories_ids: @categories_ids,
                                             group_categories_ids: @group_categories_ids)
    assert_equal service.success, true
  end

  test "should delete one category" do
    assert @group.ingredient_categories.find(@category.id)
    @group_categories_ids = [@category2.id.to_s]
    service =  RefreshCategoriesInGroup.call(group: @group,
                                             categories_ids: nil,
                                             group_categories_ids: @group_categories_ids)
    assert_equal service.success, true
    assert_not_equal IngredientCategory.find(@category.id).categories_group_id, @group.id
  end

  test "should fail with empty params" do
    service =  RefreshCategoriesInGroup.call(group: "",
                                             categories_ids: @categories_ids,
                                             group_categories_ids: @categories_group_id)
    assert_equal service.success, false
  end

  test "should add one category" do
    assert_not_equal IngredientCategory.find(@category3.id).categories_group_id, @group.id
    @categories_ids = [@category3.id.to_s]
    service =  RefreshCategoriesInGroup.call(group: @group,
                                             categories_ids: @categories_ids,
                                             group_categories_ids: nil)
    assert_equal service.success, true
    assert @group.ingredient_categories.find(@category3.id)
  end
end