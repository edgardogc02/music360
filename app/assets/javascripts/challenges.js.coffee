ready = ->
  $('#datetimepicker').datetimepicker({
    pick12HourFormat: true,
    language: 'es'
  })

$(document).ready(ready)
$(document).on('page:load', ready)