// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function() {
  
  $("#signin").bind("click",function(e){
    e.preventDefault();
    $(this).toggleClass("open");
    $(".signin_form").toggle();
    $("body").bind("click", function(e){
      if( !$(e.target).is(".signin_form, .signin_form *, #signin, #signin *") ){
        $(".signin_form").hide()
        $("#signin").removeClass("open");
        $("body").unbind("click");
      };
    });
    
  });
});
