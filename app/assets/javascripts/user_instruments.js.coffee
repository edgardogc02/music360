update_user_instrument = ->
  $(".select_instrument").click (e) ->
    e.preventDefault()
    $('#user_instrument_id').val($(this).data("instrument-id"))
    $('.edit_user').first().submit()

$(document).ready(update_user_instrument)
$(document).on('page:load', update_user_instrument)
