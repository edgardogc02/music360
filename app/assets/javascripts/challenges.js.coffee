ready = ->
  $('.datepicker').datepicker();

$(document).ready(ready)
$(document).on('page:load', ready)