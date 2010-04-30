// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//    $(this).slideUp(); 
//$(document).ready(function() {
//    $("#expand_try_it_form").live("click",function(e) {
//      $("#call_plan_form_extended").show("slow");
//      e.preventDefault();
//    });

    //$("#step_1").live("click",function() {
      //$("#instructions").replaceWith("Then do something else");
    //});
    //

jQuery.ajaxSetup({ 
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})

//Declare a function that will submit as AJAX
//jQuery.fn.submitWithAjax = function() {
 //this.submit(function () {
     //$.post($(this).attr("action"), $(this).serialize(), null, "script");
     //return false;
 //})
//};

jQuery.fn.submitWithAjax = function() {
  this.submit(function() {
    $.post(this.action, $(this).serialize(), null, "script");
    return false;
  })
  return this;
};

$(document).ready(function() {
    $("#callplan_form").submitWithAjax();
});

