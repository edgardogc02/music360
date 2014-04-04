follow_user = ->
  $(document).on 'click', '.follow_user', (e) ->
    console.log("follow")
    $(this).prev('form').submit()
    e.preventDefault()

unfollow_user = ->
  $(document).on 'click', '.unfollow_user', (e) ->
    console.log("unfollow")
    $(this).prev('form').submit()
    e.preventDefault()

$(document).ready(unfollow_user)
$(document).on('page:load', unfollow_user)

$(document).ready(follow_user)
$(document).on('page:load', follow_user)