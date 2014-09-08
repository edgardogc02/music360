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

  $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
    listing_hover_effects();
  });
};

$(document).ready(ready);
$(document).on('page:load', ready);

$( window ).resize(function() {
  progress_plus_button();
});

function progress_plus_button(){
	$.each($('.career-progress'), function( i, l ){


	var career_progress = $(this);
	var progress_bar = career_progress.children('.progress-xp');
	var btn_group = career_progress.children('.btn-group');
	var btn = btn_group.children('.btn');

	var width = progress_bar.children('.progress-bar').width();
	var parentWidth = progress_bar.offsetParent().width();
	var percent = 100*width/parentWidth;

	btn.css('height', progress_bar.height());

	if(percent < '10'){
		progress_bar.children('.progress-bar').children('span').addClass('label-complete');
	}

	if(percent < '80'){
		btn.css('width', progress_bar.width() - progress_bar.children('.progress-bar').width());
		btn_group.css('left', progress_bar.children('.progress-bar').width());
	} else {
		btn_group.css('left', progress_bar.children('.progress-bar').width() - btn_group.width());
	}

	if(percent == '100'){
		btn_group.hide();
	}

	});
}
