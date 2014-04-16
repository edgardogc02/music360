$ ->
  $(".thumbnail-grid * .thumbnail").hover (->
    $(this).children(".overlay-actions").fadeIn()
    return
  ), ->
    $(this).children(".overlay-actions").fadeOut()
    return

  return