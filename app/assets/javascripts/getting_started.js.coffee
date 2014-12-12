ready = ->
  $(document).on 'click', '.remove-challenge-player', (e) ->
    $('#challenge_player_'+$(this).data('id')).remove()
    $(this).parents('.challenged-player').remove()
    e.preventDefault()

  $(document).on 'click', '.remove-follow-player', (e) ->
    $('#follow_player_'+$(this).data('id')).remove()
    $(this).parents('.follow-player').remove()
    e.preventDefault()

  $(".select_instrument_started").click (e) ->
    e.preventDefault()
    $('#user_instrument_id').val($(this).data("instrument-id"))

$(document).ready(ready)
$(document).on('page:load', ready)
