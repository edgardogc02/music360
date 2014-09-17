# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->

  $('#welcome_wizard').bootstrapWizard();

  $("#welcome_wizard .pager.wizard a").click (e) ->
    e.preventDefault()
    return

  $("#welcome_wizard .btn-skip").click (e) ->
    e.preventDefault()
    $("#welcomeModal").modal "hide"
    return

  $(".cancel_welcome_modal").click (e) ->
    e.preventDefault()
    $("#welcomeModal").modal "hide"
    return

$(document).ready(ready)
$(document).on('page:load', ready)


