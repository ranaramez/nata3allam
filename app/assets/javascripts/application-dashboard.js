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
//= require system/less.min
//= require jquery
//= require jquery-migrate-1.2.1.min
//= require jquery/jquery.easing
//= require jquery_ujs
//= require js-beautify/beautify
//= require js-beautify/beautify-html
//= require jquery.prettyPhoto
//= require system/jquery-ui/jquery-ui-1.9.2.custom.min
//= require system/jquery-ui-touch-punch/jquery.ui.touch-punch.min
//= require system/modernizr
//= require bootstrap.min
//= require jquery-slimScroll/jquery.slimscroll.min
//= require common
//= require holder/holder
//= require forms/pixelmatrix-uniform/jquery.uniform.min
//= require bootstrap-extend/bootstrap-select/bootstrap-select
//= require jquery.toggle.buttons
//= require twitter-boostrap-hover-dropdown.min
//= require bootstrap-fileupload
//= require bootstrap-extend/bootbox
//= require wysihtml5-0.3.0_rc2.min
//= require bootstrap-wysihtml5-0.0.2.min
//= require jquery.gritter.min
//= require jquery.notyfy
//= require bootstrap-datetimepicker.min
//= require select2
//= require jquery.easy-pie-chart
//= require jquery.sparkline.min
//= require jquery.ba-resize
//= require charts/flot/jquery.flot
//= require charts/flot/jquery.flot.pie
//= require charts/flot/jquery.flot.tooltip
//= require charts/flot/jquery.flot.selection
//= require charts/flot/jquery.flot.resize
//= require charts/flot/jquery.flot.orderBars
//= require demo/charts.helper
//= require load-image.min
//= require bootstrap-image-gallery.min


$(function(){
  Holder.add_theme("dark", {background:"#000", foreground:"#aaa", size:9});
  Holder.add_theme("white", {background:"#fff", foreground:"#c9c9c9", size:9});
});

var initPieChart = function() {
      $('.percentage').easyPieChart({
          animate: 1000
      });
      $('.percentage-light').easyPieChart({
          barColor: function(percent) {
              percent /= 100;
              return "rgb(" + Math.round(255 * (1-percent)) + ", " + Math.round(255 * percent) + ", 0)";
          },
          trackColor: '#666',
          scaleColor: false,
          lineCap: 'butt',
          lineWidth: 15,
          animate: 1000
      });

      $('.updateEasyPieChart').on('click', function(e) {
        e.preventDefault();
        $('.percentage, .percentage-light').each(function() {
          var newValue = Math.round(100*Math.random());
          $(this).data('easyPieChart').update(newValue);
          $('span', this).text(newValue);
        });
      });
  };