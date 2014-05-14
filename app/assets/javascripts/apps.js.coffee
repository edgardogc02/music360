close_loading = ->
  setTimeout (->
    $("#loadingDesktopApp").modal "hide"
    return
  ), 10000
  return
$(document).ready ->
  $("a[href^='ic:'").click ->
    $("#loadingDesktopApp").modal "show"
    close_loading()
    return

  return
