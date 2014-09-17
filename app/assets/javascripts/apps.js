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
    $("#loadingDesktopApp .type").text($( this ).attr("data-type"));
    $("#loadingDesktopApp .song_name").text($( this ).attr("data-song-name"));
    $("#loadingDesktopApp .written").text($( this ).attr("data-song-writer"));
    $("#loadingDesktopApp .pubisher").text($( this ).attr("data-song-publisher"));
    close_loading();
  });

};

$(document).ready(ready);
$(document).on('page:load', ready);