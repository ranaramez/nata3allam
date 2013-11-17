function selectAll(main_checkbox, checkboxes_class){
	value = main_checkbox.checked
  $(checkboxes_class).each(function(){
    $(this).attr('checked', value);
   });
  return false;
}