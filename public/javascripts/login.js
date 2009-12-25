$(document).ready(function() {
  var login_target_form = $('form#login_register_modal');
  
  $('#user_sign_in_type_login').bind('change', function(e){
    e.preventDefault();
    login_target_form.attr('action', '/user_session');
    $('.signin_form input#user_submit').val('Sign In &raquo;');
  });
  
  $('#user_sign_in_type_register').bind('change', function(e){
    e.preventDefault();
    login_target_form.attr('action', '/users');
    $('.signin_form input#user_submit').val('Sign Up &raquo;');
  });

});