jQuery(document).ready(function(){

  var hidden_button = $(".js-import_csv_ingredient_categories");
  var import_button = $(".js-ingredient_categories-button_import");

  $(import_button).click(function() {
    $(hidden_button).click();
  });
});
