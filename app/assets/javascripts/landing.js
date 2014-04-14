$(function() {
    $('.page-scroll a').bind('click', function(event) {
        var $anchor = $(this);
        $('html, body').stop().animate({
            scrollTop: $($anchor.attr('href')).offset().top
        }, 2000, 'easeOutExpo');
        event.preventDefault();
    });
    
    $('body').scrollspy({
      offset: 200
    });
});

$(window).scroll(function() {
    if ($(".navbar").offset().top > 50) {
        $(".navbar-custom-links").addClass("top-nav-collapse");
    } else {
        $(".navbar-custom-links").removeClass("top-nav-collapse");
    }    
    parallaxScroll();    
});

 
function parallaxScroll(){
  var scrolled = $(window).scrollTop();
  $('#parallax-bg').css('top',(0-(scrolled*.75))+'px');
}
