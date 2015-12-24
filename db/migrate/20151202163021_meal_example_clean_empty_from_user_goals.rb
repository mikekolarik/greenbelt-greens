class MealExampleCleanEmptyFromUserGoals < ActiveRecord::Migration
  def up
    MealExample.all.each do |me|
      me.user_goals = me.user_goals.reject(&:empty?)
      me.save
    end
  end
end
