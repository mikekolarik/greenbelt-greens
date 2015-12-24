require 'test_helper'


class CheckZipCodeTest < ActiveSupport::TestCase
  setup do
    @range = create(:zip_code_range)
  end

  test "should include zip_code" do
    service = CheckZipCode.call(1200)
    assert_equal service.zip_code, 1200
  end

  test "should not include zip_code" do
    service = CheckZipCode.call(2500)
    assert_equal service.zip_code, nil
  end

  test "should not include blank zip_code" do
    service = CheckZipCode.call("")
    assert_equal service.zip_code, nil
  end

  test "should return correct selection" do
    service = CheckZipCode.new
    selection = service.check_inclusion(1200)
    refute selection.empty?
    selection.map { |range| assert range.zip_from <= 1200 && range.zip_to >= 1200}
  end

  test "should return empty selection" do
    service = CheckZipCode.new
    selection = service.check_inclusion(2100)
    assert selection.empty?
  end
end
