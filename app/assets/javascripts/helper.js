function reload_img_avatar() {
  $("img.thumbnail").each(function() {  
    $( this ).attr("src", $( this ).attr("src")+"?t=" + new Date().getTime());
  });    
  $(".avatar.thumbnail img").each(function() {  
    $( this ).attr("src", $( this ).attr("src")+"?t=" + new Date().getTime());
  });    
}