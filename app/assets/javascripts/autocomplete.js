$(function() {
  $( "#main-search" ).autocomplete({
    source: "/search/autocomplete",
    minLength: 2,
    select: function( event, ui ) {
     window.location = '/students/'+ui.item.id
    }
  });
});