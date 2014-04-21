$ ->
  $(".thumbnail-grid .thumbnail").hover (->
    $(this).children(".overlay-actions").slideDown(250)
    return
  ), ->
    $(this).children(".overlay-actions").slideUp(250)
    return
  
  $container = $(".thumbnail-grid")
  $container.imagesLoaded ->
    $container.masonry
      itemSelector: ".masonry-img"
      columnWidth: ".masonry-img"
      transitionDuration: 0
  
    return

  return
