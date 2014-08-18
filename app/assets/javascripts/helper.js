function reload_img_avatar() {
  $("img.thumbnail").each(function() {
    refresh_img(refresh_img($(this)))
  });    
  $(".avatar.thumbnail img").each(function() {  
    refresh_img(refresh_img($(this)))
  });    
}

function reload_img_group() {
  $(".cover-group img.cover-img").each(function() {
    refresh_img(refresh_img($(this)))
  });    
  $(".cover-group img.profile-group-img").each(function() {  
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
};

$(document).ready(ready);
$(document).on('page:load', ready);