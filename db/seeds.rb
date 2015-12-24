# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

users = User.create([{"email" => "user1@email.com", "password" => "12345678", "password_confirmation" => "12345678"}, {"email" => "user2@email.com", "password" => "12345678", "password_confirmation" => "12345678"}])

DietaryPreference.create([{name: "I`ll eat it all!",                  picture: File.open(Rails.root.join('test', 'fixtures', 'files', 'preference.svg'))},
                          {name: "Vegetarian",                        picture: File.open(Rails.root.join('test', 'fixtures', 'files', 'preference.svg'))},
                          {name: "Dairy Free",                        picture: File.open(Rails.root.join('test', 'fixtures', 'files', 'preference.svg'))},
                          {name: "I have specific nutritional goals", picture: File.open(Rails.root.join('test', 'fixtures', 'files', 'preference.svg'))},
                          {name: "Vegan",                             picture: File.open(Rails.root.join('test', 'fixtures', 'files', 'preference.svg'))},
                          {name: "Gluten Free",                       picture: File.open(Rails.root.join('test', 'fixtures', 'files', 'preference.svg'))}])

DietaryGoal.create([{name: "High protein",    picture: File.open(Rails.root.join('test', 'fixtures', 'files', 'goal.svg'))},
                    {name: "Low carb",        picture: File.open(Rails.root.join('test', 'fixtures', 'files', 'goal.svg'))},
                    {name: "Low calories",    picture: File.open(Rails.root.join('test', 'fixtures', 'files', 'goal.svg'))},
                    {name: "Low fat",         picture: File.open(Rails.root.join('test', 'fixtures', 'files', 'goal.svg'))},
                    {name: "Low sugar",       picture: File.open(Rails.root.join('test', 'fixtures', 'files', 'goal.svg'))},
                    {name: "Macro based",     picture: File.open(Rails.root.join('test', 'fixtures', 'files', 'goal.svg'))}])

Ingredient.create([{name: "Wild rice"},
                   {name: "Cucumber"},
                   {name: "Egg"},
                   {name: "Meat"},
                   {name: "Milk"},
                   {name: "Tomato"}])

IngredientCategory.create([{name: "Bases"},
                           {name: "Protein"},
                           {name: "Vegetables"},
                           {name: "Fruits"},
                           {name: "Cheeses"},
                           {name: "Nuts & Seeds"},
                           {name: "Crunch"},
                           {name: "Dressings"}])

20.times do |i|
  HelpBlock.create([{key: "Help Block #{i+1}",  description: "Description for Help Block #{i+1}"}])
end

20.times do |i|
  MealExample.create([{user_name: "UserName#{i}",
                     user_avatar: File.open(Rails.root.join('test', 'fixtures', 'files', 'avatar1.png')),
                     meal_photo: File.open(Rails.root.join('test', 'fixtures', 'files', 'intro_screen_block_salad.png')),
                     meal_ingredients: "Chiken#{i}, Salad#{i}, Tomatos#{i}",
                     user_goals: [DietaryGoal.first.name, DietaryGoal.last.name]}])
end

MealType.create([{key: "all_salads", description: "All salads", order: "10"},
                 {key: "more_salads", description: "More Salads", order: "20"},
                 {key: "balanced", description: "Balanced", order: "30"},
                 {key: "more_grains", description: "More Grains", order: "40"},
                 {key: "all_grains", description: "All Grains", order: "50"}])
