#fb_root = null
#fb_events_bound = false

#$ ->
#  bindFacebookEvents() unless fb_events_bound

#bindFacebookEvents = ->
#  $(document)
#    .on('page:fetch', saveFacebookRoot)
#    .on('page:change', restoreFacebookRoot)
#    .on('page:load', ->
#      FB.XFBML.parse()
#    )
#  fb_events_bound = true

#saveFacebookRoot = ->
#  fb_root = $('#fb-root').detach()

#restoreFacebookRoot = ->
#  if $('#fb-root').length > 0
#    $('#fb-root').replaceWith fb_root
#  else
#    $('body').append fb_root
