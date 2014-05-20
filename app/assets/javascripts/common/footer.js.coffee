$ ->
  unless $("body").hasClass("sessions")
    #console.log 'no es landing';
    stickyfooter = undefined
    stickyfooter = ->
      footerHeight = undefined
      footerHeight = $("footer").outerHeight()
      $("#page-wrap").css "padding-bottom", footerHeight
      $("footer").css "margin-top", -footerHeight
      return

    stickyfooter()
    $(window).on "resize", stickyfooter
  return