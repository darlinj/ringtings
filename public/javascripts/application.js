// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//    $(this).slideUp(); 
$(document).ready(function() {
    $("#expand_try_it_form").live("click",function(e) {
      $("#call_plan_form_extended").show("slow");
      e.preventDefault();
    });

    //$("#step_1").live("click",function() {
      //$("#instructions").replaceWith("Then do something else");
    //});

});

