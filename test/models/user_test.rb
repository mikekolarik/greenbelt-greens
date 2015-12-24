require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should validate_length_of(:first_name)
  should validate_length_of(:last_name)
  should have_and_belong_to_many(:ingredients)
  should have_and_belong_to_many(:dietary_goals)
  should have_and_belong_to_many(:dietary_preferences)
  should belong_to(:meal_type)
  should validate_numericality_of(:phone)
end
