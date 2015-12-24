$.fn.add_meal_id_to_input = function($input_with_stringified, meal_id){
  $input_with_stringified.val(meal_id);
}

jQuery(document).ready(function(){
  var $input_monday_meal = $(".js-monday");
  var $input_tuesday_meal = $(".js-tuesday");
  var $input_wednesday_meal = $(".js-wednesday");
  var $input_thursday_meal = $(".js-thursday");
  var $input_friday_meal = $(".js-friday");

  $(".js-meal").click(function(){
    var meal_id = $(this).data('meal-id');
    var day_of_week = $(this).data('day');

    if(day_of_week == "Monday"){
      $.fn.add_meal_id_to_input($input_monday_meal, meal_id);
    }
    if(day_of_week == "Tuesday"){
      $.fn.add_meal_id_to_input($input_tuesday_meal, meal_id);
    }
    if(day_of_week == "Wednesday"){
      $.fn.add_meal_id_to_input($input_wednesday_meal, meal_id);
    }
    if(day_of_week == "Thursday"){
      $.fn.add_meal_id_to_input($input_thursday_meal, meal_id);
    }
    if(day_of_week == "Friday"){
      $.fn.add_meal_id_to_input($input_friday_meal, meal_id);
    }
  });
});