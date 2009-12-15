//Will make inline labels and hint text
//
//Prefers hint text, any element inside the LI with class 'inline-hints'
//Will use label if no inline-hint is found
//Can select inputs with hints with selector $("input:hints")

//could jsut make label hae the .inline-hints class too, get rid of the inlineitem function
// this plug in is retarded. it assumes too much, the label has a special css class that controls where it is,
// where as the inline-hint css is overridden by JS. 

//add in a force label, force hint
(function($) {

 $.fn.inlineFormElements = function(settings) {
   
   //not sure what kind of settings we need
   //color, class, what else?
    var config = {'foo': 'bar'};

    if (settings) $.extend(config, settings);
    
    this.each(function() {
      
      var inlineItem = $(this).getInlineItem();

      //if the input field is empty show the hint
      !$(this).val() ? $(inlineItem).show() : $(inlineItem).hide();
      
      //when you focus on the input element, if is empty 1) stop any current animations 2) fade out  
      $(this).bind("focus", function(){
        if (!$(this).val()) $(inlineItem).stop(true, true).fadeOut("fast");
      });
  
      //when you lose focus of the input element, if it is empty 1) stop current animation 2) fade in
      $(this).bind("blur", function(){
        if (!$(this).val()) $(inlineItem).stop(true, true).fadeIn("fast");
      });  
      
      return this;
    });
 }
  
 //returns the element we are going to use as our text, prefers inline hints over labels
 $.fn.getInlineItem = function() {
   
   var hint = $(this).siblings(".inline-hints");       
   var label = $("label[for='" + $(this).attr("id")+ "']");
   return (hint.length > 0) ? hint : label;
 }
})(jQuery);

jQuery.extend(
 jQuery.expr[ ":" ], {
   hints: function(a){
     return $(a).siblings('.inline-hints').size();
   }
 }
);

