close_loading = ->
  setTimeout (->
    $("#loadingDesktopApp").modal "hide"
    return
  ), 10000
  return
$(document).ready ->
  $("a.app-play").click ->
    $("#loadingDesktopApp").modal "show"
    close_loading()
    return

  return
  
#$(".download_btn").click (e) ->
#  e.preventDefault()
#  action = $(this).attr("href")
#  $("#getReady").modal("show").on "shown.bs.modal", ->
#    window.setTimeout (->
#      $("#getReady").modal("hide").on "hidden.bs.modal", ->
#        
#        #window.open(action);
#        window.location = action
#        window.focus()
#        return
#
#      return
#    ), 4000
#    return

  return
