ready = ->
  $(document).on 'click', '.remove-challenge-player', (e) ->
    $('#challenge_player_'+$(this).data('id')).remove()
    $(this).parents('.challenged-player').remove()
    if $('.challenged-player').length == 0
      $('.btn-full-width').prop('disabled', true)
    e.preventDefault()

  $(document).on 'click', '.remove-follow-player', (e) ->
    $('#follow_player_'+$(this).data('id')).remove()
    $(this).parents('.follow-player').remove()
    if $('.follow-player').length == 0
      $('.btn-full-width').prop('disabled', true)
    e.preventDefault()

  $(".select_instrument_started").click (e) ->
    e.preventDefault()
    $('#user_instrument_id').val($(this).data("instrument-id"))

$(document).ready(ready)
$(document).on('page:load', ready)
