parallaxScroll = ->
  scrolled = $(window).scrollTop()
  $("#parallax-bg").css "top", (0 - (scrolled * .75)) + "px"
  return
$ ->
  $(".page-scroll a").bind "click", (event) ->
    $anchor = $(this)
    $("html, body").stop().animate
      scrollTop: $($anchor.attr("href")).offset().top
    , 2000, "easeOutExpo"
    event.preventDefault()
    return

  $("body").scrollspy offset: 200
  return

$(window).scroll ->
  if $(".navbar").offset().top > 50
    $(".navbar-custom-links").addClass "top-nav-collapse"
  else
    $(".navbar-custom-links").removeClass "top-nav-collapse"
  parallaxScroll()
  return