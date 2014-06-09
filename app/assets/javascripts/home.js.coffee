# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $("#welcomeModal").modal
    backdrop: "static"
    keyboard: false
    show: true

  $(".cancel_welcome_modal").click (e) ->
    e.preventDefault()
    $("#welcomeModal").modal "hide"
    return

  return
  

