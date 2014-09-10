root = exports ? this

root.click_on_comment_link = ->
  $(".comment_link").click (e) ->
    $(this).parent().parent().parent('.post_actions').find('#activity_comment_comment').focus()
    e.preventDefault()

$(document).ready(click_on_comment_link)
$(document).on('page:load', click_on_comment_link)

