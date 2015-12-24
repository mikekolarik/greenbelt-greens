jQuery(document).ready(function(){

  var hidden_button = $(".js-import_csv_ingredients");
  var import_button = $(".js-ingredients-button_import");

  $(import_button).click(function() {
    $(hidden_button).click();
  });
});
