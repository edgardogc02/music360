var login_view;
var sign_up_view;
var login_view_footer;
var sign_up_view_footer;

$(document).ready(function() {  
  
  login_view = $(".login-view");
  sign_up_view = $(".sign-up-view");
  login_view_footer = $(".login-view-footer");
  sign_up_view_footer = $(".sign-up-view-footer"); 
  
  $(".authentication-btn").click(function(e) {    
    e.preventDefault();
    show_modal_authentication($(this).data("id"));
  });
  
  $("#sign-up-slide-btn").click(function(e) {
    e.preventDefault();
    show_sign_up();
  });
  $("#log-in-slide-btn").click(function(e) {
    e.preventDefault();
    show_login();
  });
  
});

function show_modal_authentication(action_prm, modal_type_prm) {
  var action = action_prm;
  var modal_type = modal_type_prm;
 
  hide_sliders();
    
  $("#SignIn .modal-body #action_modal").val(action);
    
  if (action == "download"){
    show_sign_up();
  }else{
    show_login();
  }    
  if (modal_type == true){
    $("#SignIn").modal({
      show: true,
      backdrop: 'static'
    });
  }else{
    $("#SignIn").modal('show');
  }  
}

function show_sign_up() {
  login_view.slideUp();
  sign_up_view.slideDown();
  sign_up_view_footer.slideDown();
  login_view_footer.slideUp();
}

function show_login() {
  login_view.slideDown();
  sign_up_view.slideUp();
  login_view_footer.slideDown();
  sign_up_view_footer.slideUp();
}

function hide_sliders() {
  login_view.css('display', 'none');
  sign_up_view.css('display', 'none');
  
  login_view_footer.css('display', 'none');
  sign_up_view_footer.css('display', 'none');
}

window.onload = function () {
    document.getElementById("password_reset_1").onchange = validatePassword;
    document.getElementById("password_reset_2").onchange = validatePassword;
}
function validatePassword(){
var pass2=document.getElementById("password_reset_1").value;
var pass1=document.getElementById("password_reset_2").value;
if(pass1!=pass2)
    document.getElementById("password_reset_1").setCustomValidity("Password doesn't match");
else
    document.getElementById("password_reset_2").setCustomValidity('');  
}
