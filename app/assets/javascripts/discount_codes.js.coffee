generate_discount_code = ->
  $("#generate_discount_code").click (e) ->
    $('#discount_code_code').val(Math.random().toString(36).substring(7).toUpperCase())
    e.preventDefault()

$(document).ready(generate_discount_code)
$(document).on('page:load', generate_discount_code)
