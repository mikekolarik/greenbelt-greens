FactoryGirl.define do
  factory :intro_screen_block, class: IntroScreenBlock do
    sequence(:title)           {|n| "IntroScreenBlock Title#{n}"}
    sequence(:description)     {|n| "IntroScreenBlock Descrtiption#{n}"}
    sequence(:picture)         {|n| fixture_file_upload(Rails.root.join('test', 'fixtures', 'files', 'intro_screen_block_salad.png'), 'image/png')}
  end

  factory :categories_group, class: CategoriesGroup do
    sequence(:name)            {|n| "Some group#{n}"}
  end

  factory :ingredient_category, class: IngredientCategory do
    sequence(:name)            {|n| "Some category#{n}"}
  end

  factory :ingredient, class: Ingredient do
    sequence(:name)            {|n| "Some ingredient#{n}"}
  end

  factory :dietary_goal, class: DietaryGoal do
    sequence(:name)           {|n| "Dietary Goal Name#{n}"}
    sequence(:picture)        {|n| fixture_file_upload(Rails.root.join('test', 'fixtures', 'files', 'goal.svg'), 'image/svg')}
  end

  factory :dietary_preference, class: DietaryPreference do
    sequence(:name)           {|n| "Dietary Preference Name#{n}"}
    sequence(:picture)        {|n| fixture_file_upload(Rails.root.join('test', 'fixtures', 'files', 'preference.svg'), 'image/svg')}
  end

  factory :help_block, class: HelpBlock do
    sequence(:key)           {|n| "Help Block Key#{n}"}
    sequence(:description)   {|n| "Help Block Descrtiption#{n}"}
  end

  factory :meal_example, class: MealExample do
    sequence(:user_avatar)     { fixture_file_upload(Rails.root.join('test', 'fixtures', 'files', 'avatar1.png'), 'image/png') }
    sequence(:user_name)       { |n| "UserName#{n}" }
    sequence(:user_goals)      { ["Dietary Goal Name1"] }
    sequence(:meal_photo)      { fixture_file_upload(Rails.root.join('test', 'fixtures', 'files', 'intro_screen_block_salad.png'), 'image/png') }
    sequence(:meal_ingredients){ "ingr1, ingr2, ingr3" }
  end

  factory :meal_type, class: MealType do
    sequence(:key)           {|n| "Meal Type Key#{n}"}
    sequence(:description)   {|n| "Meal Type Descrtiption#{n}"}
  end

  factory :user, class: User do
    sequence(:email)           { |n| "example#{n}@mail.com" }
    sequence(:password)        { |n| "password#{n}" }
    sequence(:zip_code)        { "0001" }
    sequence(:plan_id)         { 10028 }
  end

  factory :zip_code_range, class: ZipCodeRange do
    sequence(:zip_from)            { |n| 1000 }
    sequence(:zip_to)              { |n| 2000 }
  end
end
