var ready;

close_loading = function() {
  setTimeout((function() {
    $("#loadingDesktopApp").modal("hide");
  }), 10000);
};

ready = function() {

  $("a.app-play").click(function(e) {
    $("#loadingDesktopApp").modal("show");
    $("#loadingDesktopApp .image-loading").attr('src', $( this ).attr("data-song-cover"));
    $("#loadingDesktopApp #song_name").text($( this ).attr("data-song-name"));
    $("#loadingDesktopApp #song_name").text($( this ).attr("data-song-name"));
    $("#loadingDesktopApp #song_name").text($( this ).attr("data-song-name"));
    $("#loadingDesktopApp #song_name").text($( this ).attr("data-song-name"));
    $("#loadingDesktopApp #song_name").text($( this ).attr("data-song-name"));
    close_loading();
  });
  
  console.log("asdasd");

};

$(document).ready(ready);
$(document).on('page:load', ready);