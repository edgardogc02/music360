var login_view;
var sign_up_view;
var login_view_footer;
var sign_up_view_footer;
var href_signin;
var href_login;

var ready;
ready = function() {
	login_view = $(".login-view");
  sign_up_view = $(".sign-up-view");
  login_view_footer = $(".login-view-footer");
  sign_up_view_footer = $(".sign-up-view-footer");

  href_signin = $('#facebook_signin').attr("href");
  href_login = $('#facebook_signin_4').attr("href");

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
};

$(document).ready(ready);
$(document).on('page:load', ready);


function show_modal_authentication(action_prm, modal_type_prm) {
  var action = action_prm;
  var modal_type = modal_type_prm;

  hide_sliders();

  $("#SignIn .modal-body #action_modal").val(action);

  if (action == "download"){
		$('#facebook_signin_4').attr("href", href_signin+"?new_session_action=download");
		$('#facebook_signin').attr("href", href_login+"?new_session_action=download");
		show_sign_up();
  }else{
  	$('#facebook_signin_4').attr("href", href_signin);
		$('#facebook_signin').attr("href", href_login);
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