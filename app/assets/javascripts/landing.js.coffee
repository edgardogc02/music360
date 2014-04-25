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
  #parallaxScroll()
  return

$ ->
  $("#video").on "hidden.bs.modal", ->
    $("#video div.modal-body").html ""
    return

  $("#video").on "shown.bs.modal", ->
    $("#video div.modal-body").html "<div class='video-container'><iframe width='560' height='315' src='//www.youtube.com/embed/pSBiT91e5nk?rel=0' frameborder='0' allowfullscreen></iframe></div>"
    return
  
  $(".sessions.new .navbar-collapse a").on "click", ->
    $(".sessions.new .navbar-toggle").click()
    return

  return
