$ ->
  $(".page-scroll a").bind "click", (event) ->
    $anchor = $(this)
    $("html, body").stop().animate
      scrollTop: $($anchor.attr("href")).offset().top
    , 1700, "easeOutExpo"
    event.preventDefault()
    return
    
    #$("body").scrollspy offset: 1000
  return

$(window).resize ->
  $("[data-spy=\"scroll\"]").each ->
    console.log("refreh")
    $spy = $(this).scrollspy("refresh")
    return

  return


$(window).scroll ->
  if $(".navbar").offset().top > 50
    $(".navbar-custom-links").addClass "top-nav-collapse"
  else
    $(".navbar-custom-links").removeClass "top-nav-collapse"
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
