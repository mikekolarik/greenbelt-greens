# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151225083157) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories_groups", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "order_index", default: 0
  end

  create_table "common_params", force: :cascade do |t|
    t.date     "service_start_date", default: '2015-12-13'
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.integer  "discount_value",     default: 1000
  end

  create_table "dietary_goals", force: :cascade do |t|
    t.string   "name"
    t.integer  "sort_number"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "picture"
  end

  create_table "dietary_goals_ingredients", id: false, force: :cascade do |t|
    t.integer "ingredient_id"
    t.integer "dietary_goal_id"
  end

  add_index "dietary_goals_ingredients", ["dietary_goal_id"], name: "index_dietary_goals_ingredients_on_dietary_goal_id", using: :btree
  add_index "dietary_goals_ingredients", ["ingredient_id"], name: "index_dietary_goals_ingredients_on_ingredient_id", using: :btree

  create_table "dietary_goals_users", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "dietary_goal_id"
  end

  add_index "dietary_goals_users", ["dietary_goal_id"], name: "index_dietary_goals_users_on_dietary_goal_id", using: :btree
  add_index "dietary_goals_users", ["user_id"], name: "index_dietary_goals_users_on_user_id", using: :btree

  create_table "dietary_preferences", force: :cascade do |t|
    t.string   "name"
    t.integer  "sort_number"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "picture"
  end

  create_table "dietary_preferences_ingredients", id: false, force: :cascade do |t|
    t.integer "ingredient_id"
    t.integer "dietary_preference_id"
  end

  add_index "dietary_preferences_ingredients", ["dietary_preference_id"], name: "index_dietary_preferences_ingredients_on_dietary_preference_id", using: :btree
  add_index "dietary_preferences_ingredients", ["ingredient_id"], name: "index_dietary_preferences_ingredients_on_ingredient_id", using: :btree

  create_table "dietary_preferences_users", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "dietary_preference_id"
  end

  add_index "dietary_preferences_users", ["dietary_preference_id"], name: "index_dietary_preferences_users_on_dietary_preference_id", using: :btree
  add_index "dietary_preferences_users", ["user_id"], name: "index_dietary_preferences_users_on_user_id", using: :btree

  create_table "help_blocks", force: :cascade do |t|
    t.string   "key"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "ingredient_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "categories_group_id"
  end

  create_table "ingredients", force: :cascade do |t|
    t.string   "name"
    t.integer  "ingredient_category_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "ingredients", ["ingredient_category_id"], name: "index_ingredients_on_ingredient_category_id", using: :btree

  create_table "ingredients_users", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "ingredient_id"
  end

  add_index "ingredients_users", ["ingredient_id"], name: "index_ingredients_users_on_ingredient_id", using: :btree
  add_index "ingredients_users", ["user_id"], name: "index_ingredients_users_on_user_id", using: :btree

  create_table "intro_screen_blocks", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "picture"
    t.integer  "order_index", default: 0
  end

  create_table "meal_examples", force: :cascade do |t|
    t.string   "user_name"
    t.string   "user_avatar"
    t.text     "user_goals",          default: [],              array: true
    t.string   "meal_photo"
    t.text     "meal_ingredients"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "dietary_preferences", default: [],              array: true
    t.string   "calories"
    t.string   "carbs"
    t.string   "fat"
    t.string   "protein"
  end

  create_table "meal_types", force: :cascade do |t|
    t.string   "key"
    t.text     "description"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "order",       default: 0
  end

  create_table "new_areas", force: :cascade do |t|
    t.string   "user_email"
    t.string   "user_zip_code"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "popover_contents", force: :cascade do |t|
    t.text     "content"
    t.string   "picture"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "order_index", default: 0
    t.string   "header"
    t.string   "sub_header"
  end

  create_table "referral_codes", force: :cascade do |t|
    t.string   "secret_code"
    t.integer  "user_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "referral_emails",       default: [],              array: true
    t.string   "referral_customer_ids", default: [],              array: true
    t.string   "owner_email"
    t.integer  "discount_value"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "zip_code"
    t.string   "authentication_token"
    t.boolean  "admin",                  default: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "address1"
    t.string   "address2"
    t.string   "phone"
    t.text     "delivery_instructions"
    t.string   "customer_id"
    t.integer  "plan_id"
    t.string   "subscription_id"
    t.string   "facebook_id"
    t.integer  "meal_type_id"
    t.integer  "referral_code_id"
    t.string   "weekend_delivery_range"
    t.string   "weekday_delivery_range"
    t.date     "first_delivery_date"
    t.decimal  "total_amount",           default: 0.0
    t.integer  "number_of_meals"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "zip_code_ranges", force: :cascade do |t|
    t.integer  "zip_from"
    t.integer  "zip_to"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
