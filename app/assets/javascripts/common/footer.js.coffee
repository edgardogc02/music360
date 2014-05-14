$ ->
  stickyfooter = ->
    footerHeight = $("footer").outerHeight()
    $("#page-wrap").css "padding-bottom", footerHeight
    
    #$("#page-wrap").css("margin-bottom", -footerHeight);
    $("footer").css "margin-top", -footerHeight
    console.log "sticky: " + footerHeight
    return
  stickyfooter()
  $(window).on "resize", stickyfooter
  return