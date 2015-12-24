$.fn.remove_tag_id_from_all = function(array_with_all_inputs, tag_id){
  for(var i = array_with_all_inputs.length - 1; i >= 0; i-- ){
    var array = array_with_all_inputs[i].val().split(",");
    array = $.map(array, function(a){if(a !== ""){return a;}});
    var index = array.indexOf(tag_id.toString());
    if(index !== -1){
      array.splice(index, 1);
      var string_from_array = array.toString();
      array_with_all_inputs[i].val(string_from_array);
    }
  }
}

$.fn.add_tag_id_to_input = function($input_with_stringified_array, tag_id){
  var array = $input_with_stringified_array.val().split(",");
  array = $.map(array, function(a){if(a !== ""){return a;}});
  if(array.indexOf(tag_id) == -1){
    array.push(tag_id);
    var string_from_array = array.toString();
    $input_with_stringified_array.val(string_from_array);
  }
}

jQuery(document).ready(function(){
  var $like = $(".js-like");
  var $dislike = $(".js-dislike");
  var $hate = $(".js-hate");
  var $must_have = $(".js-must-have");

  var $input_hated_ids = $(".js-hated_ids");
  var $input_liked_ids = $(".js-liked_ids");
  var $input_disliked_ids = $(".js-disliked_ids");
  var $input_must_have_ids = $(".js-must_have_ids");

  var array_with_all_inputs = [$input_liked_ids, $input_disliked_ids, $input_hated_ids, $input_must_have_ids];

  $($dislike).click(function(){
    var tag_id = $(this).closest('.js-tag-item').data('tag-id');

    $.fn.remove_tag_id_from_all(array_with_all_inputs, tag_id);

    $.fn.add_tag_id_to_input($input_disliked_ids, tag_id);
  });

  $($hate).click(function(){
    var tag_id = $(this).closest('.js-tag-item').data('tag-id');

    $.fn.remove_tag_id_from_all(array_with_all_inputs, tag_id);

    $.fn.add_tag_id_to_input($input_hated_ids, tag_id);
  });

  $($must_have).click(function(){
    var tag_id = $(this).closest('.js-tag-item').data('tag-id');

    $.fn.remove_tag_id_from_all(array_with_all_inputs, tag_id);

    $.fn.add_tag_id_to_input($input_must_have_ids, tag_id);
  });

  $($like).click(function(){
    var tag_id = $(this).closest('.js-tag-item').data('tag-id');

    $.fn.remove_tag_id_from_all(array_with_all_inputs, tag_id);

    $.fn.add_tag_id_to_input($input_liked_ids, tag_id);
  });
});