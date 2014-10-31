cart_mark_as_gift = ->
  $("#cart_mark_as_gift").click ->
    $(this).parents('form').submit()

$(document).ready(cart_mark_as_gift)
$(document).on('page:load', cart_mark_as_gift)
