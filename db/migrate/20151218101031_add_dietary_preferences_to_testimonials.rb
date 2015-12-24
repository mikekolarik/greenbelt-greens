class AddDietaryPreferencesToTestimonials < ActiveRecord::Migration

  def up
    if table_exists? :meal_examples
      add_column :meal_examples, :dietary_preferences, :string, array: true, default: [] unless column_exists? :meal_examples, :dietary_preferences
      add_column :meal_examples, :calories, :string unless column_exists? :meal_examples, :calories
      add_column :meal_examples, :carbs, :string unless column_exists? :meal_examples, :carbs
      add_column :meal_examples, :fat, :string unless column_exists? :meal_examples, :fat
      add_column :meal_examples, :protein, :string unless column_exists? :meal_examples, :protein
    end

    if table_exists? :popover_contents
      add_column :popover_contents, :header, :string unless column_exists? :popover_contents, :header
      add_column :popover_contents, :sub_header, :string unless column_exists? :popover_contents, :sub_header
    end
  end


  def down
    if table_exists? :meal_examples
      remove_column :meal_examples, :dietary_preferences if column_exists? :meal_examples, :dietary_preferences
      remove_column :meal_examples, :calories, :string if column_exists? :meal_examples, :calories
      remove_column :meal_examples, :carbs, :string if column_exists? :meal_examples, :carbs
      remove_column :meal_examples, :fat, :string if column_exists? :meal_examples, :fat
      remove_column :meal_examples, :protein, :string if column_exists? :meal_examples, :protein
    end

    if table_exists? :popover_contents
      remove_column :popover_contents, :header if column_exists? :popover_contents, :header
      remove_column :popover_contents, :sub_header if column_exists? :popover_contents, :sub_header
    end
  end

end


