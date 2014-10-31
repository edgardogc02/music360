generate_code = ->
  $("#generate_code").click (e) ->
    $('#code').val(Math.random().toString(36).substring(7).toUpperCase())
    e.preventDefault()

$(document).ready(generate_code)
$(document).on('page:load', generate_code)
