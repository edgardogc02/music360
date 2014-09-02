function reload_img_avatar() {
  $("img.thumbnail").each(function() {
    refresh_img(refresh_img($(this)))
  });
  $(".avatar.thumbnail img").each(function() {
    refresh_img(refresh_img($(this)))
  });
}

function reload_img_group() {
  $(".top-images img.cover-img").each(function() {
    refresh_img(refresh_img($(this)))
  });
  $(".top-images img.profile-img").each(function() {
    refresh_img(refresh_img($(this)))
  });
}

function refresh_img(e) {
  $(e).attr("src", $(e).attr("src")+"?t=" + new Date().getTime());
}

var ready;
ready = function() {
  $('body').scrollspy({
    target: '.bs-docs-sidebar',
    offset: 40
  });

	progress_plus_button();


};

$(document).ready(ready);
$(document).on('page:load', ready);

function progress_plus_button(){
	var progress_bar = $('.progress-xp');
	var btn_group = $('.career-progress .btn-group');
	var btn = $('.career-progress .btn-group .btn');

	var width = progress_bar.children('.progress-bar').width();
	var parentWidth = progress_bar.offsetParent().width();
	var percent = 100*width/parentWidth;

	btn.css('height', progress_bar.height());

	if(percent < '10'){
		progress_bar.children('.progress-bar').children('span').addClass('label-complete');
	}

	if(percent < '91'){
		btn.css('width', progress_bar.width() - progress_bar.children('.progress-bar').width());
		btn_group.css('left', progress_bar.children('.progress-bar').width());
	} else {
		btn_group.css('left', progress_bar.children('.progress-bar').width() - btn_group.width());
	}

	if(percent == '100'){
		btn_group.hide();
	}
}
