// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//


//= require jquery.min
//= require base
//= require jquery.fitvids
//= require jquery.meanmenu
//= require jquery.flexslider-min
//= require jquery.inview
//= require jquery.scrollParallax.min
function filter_students(index) {
  
  var value = $("#search-bar").val();
  var spinner = $('.spinner')
  spinner.removeClass('invisible')
  $.ajax({
    type: 'GET',
    url: "students.js?page=" + index + "&term=" +value,
    success: function() {
      setTimeout(function(){ 
        spinner.addClass('invisible')
      }, 300)
    }
  })
}

function hide_message() {
  $('.alert-box').addClass('hidden');
}


