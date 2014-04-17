$ ->
  $(".thumbnail-grid .thumbnail").hover (->
    $(this).children(".overlay-actions").fadeIn()
    return
  ), ->
    $(this).children(".overlay-actions").fadeOut()
    return
  
  $container = $(".fixed-grid")
  $container.isotope itemSelector: ".thumbnail"
  return

  return
