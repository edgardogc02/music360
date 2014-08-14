function reload_img_avatar() {
  $("img.thumbnail").each(function() {  
    $( this ).attr("src", $( this ).attr("src")+"?t=" + new Date().getTime());
  });    
  $(".avatar.thumbnail img").each(function() {  
    $( this ).attr("src", $( this ).attr("src")+"?t=" + new Date().getTime());
  });    
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