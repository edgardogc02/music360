payment_method_selected = ->
  $(".select_payment_method").click (e) ->
    e.preventDefault()
    $("#user_premium_subscription_form").removeClass("hide")
    $("#user_premium_subscription_form_payment_method_id").val($(this).data("payment-method-id"))

$(document).ready(payment_method_selected)
$(document).on('page:load', payment_method_selected)
