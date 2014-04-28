root = exports ? this

root.listing_hover_effects = ->
  $(".thumbnail-grid .thumbnail").hover (->
    $(this).children(".overlay-actions").show()
    return
  ), ->
    $(this).children(".overlay-actions").hide()
    return

  $container = $(".thumbnail-grid")
  $container.imagesLoaded ->
    $container.masonry
      itemSelector: ".masonry-img"
      columnWidth: ".masonry-img"
      transitionDuration: 0

    return

  return

$(document).ready(listing_hover_effects)
$(document).on('page:load', listing_hover_effects)