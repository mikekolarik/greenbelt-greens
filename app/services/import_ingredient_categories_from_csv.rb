require "csv"

class ImportIngredientCategoriesFromCsv
  include Concerns::Service
  attr_accessor :success

  def call(csv_file)
    if csv_file.blank?
      @success = false
    else
      _import_ingredients(csv_file)
    end
  end

  private

  def _import_ingredients(csv_file)
    CSV.foreach(csv_file.path, headers: true) do |row|
      if row.include?('name')
        ingredient = IngredientCategory.find_by_name(row["name"]) || IngredientCategory.new
        ingredient.attributes = row.to_hash
        ingredient.save
        @success = true
      else
        @success = false
      end
    end
  end
end