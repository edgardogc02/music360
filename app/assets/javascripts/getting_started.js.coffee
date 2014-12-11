ready = ->
  $(document).on 'click', '.remove-challenge-player', (e) ->
    $('#challenge_player_'+$(this).data('id')).remove()
    $(this).parents('.challenged-player').remove()
    e.preventDefault()

  $(document).on 'click', '.remove-follow-player', (e) ->
    $('#follow_player_'+$(this).data('id')).remove()
    $(this).parents('.follow-player').remove()
    e.preventDefault()

$(document).ready(ready)
$(document).on('page:load', ready)
