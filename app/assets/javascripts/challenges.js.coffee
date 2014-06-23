$(document).ready ->
  $("#selectUser").on "shown.bs.modal", ->
    listing_hover_effects()
    return

  $("#selectSong").on "shown.bs.modal", ->
    listing_hover_effects()
    return

  return