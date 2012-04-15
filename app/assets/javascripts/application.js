// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require simple_datatables


$(function (){
	$('#task_start_at').datepicker({dateFormat: 'yy-mm-dd'});
	$('#task_end_at').datepicker({dateFormat: 'yy-mm-dd'});
	$('#event_start_at').datepicker({dateFormat: 'yy-mm-dd'});
	$('#event_end_at').datepicker({dateFormat: 'yy-mm-dd'});
});

/**$(function() {
  $("#task_div th a, #tasks .pagination a").live("click", function() {
    $.getScript(this.href);
    return false;
  });
  $("#task_div_search input").keyup(function() {
    $.get($("#task_div_search").attr("action"), $("#task_div_search").serialize(), null, "script");
    return false;
  });
});**/



$(document).ready(function(){
	$('#example').dataTable();
});

$(document).ready(function(){$('.toggle:not(.toggle-open)') .addClass('toggle-closed') .parents('li') .children('ul') .hide();    

$('.toggle') .click(function(){
   if ($(this) .hasClass('toggle-open')) {
     $(this) .removeClass('toggle-open') .addClass('toggle-closed') .empty('') .append('+') .parents('li') .children('ul') .slideUp(250);
     $(this) .parent('.menutop') .removeClass('menutop-open') .addClass('menutop-closed');
   }else{
     $(this) .parent('.menutop') .removeClass('menutop-closed') .addClass('menutop-open');
     $(this) .removeClass('toggle-closed') .addClass('toggle-open') .empty('') .append('&ndash;') .parents('li') .children('ul') .slideDown(250);
 }
 })
 });
 
function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".fields").hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).parent().before(content.replace(regexp, new_id));
}