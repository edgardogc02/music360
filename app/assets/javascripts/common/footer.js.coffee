$ ->
  unless $("body").hasClass("sessions")
    stickyfooter = undefined
    stickyfooter = ->
      footerHeight = undefined
      footerHeight = $("footer").outerHeight()
      $("#page-wrap").css "padding-bottom", footerHeight + 30
      $("footer").css "margin-top", -footerHeight
      return

    stickyfooter()
    $(window).on "resize", stickyfooter
  return