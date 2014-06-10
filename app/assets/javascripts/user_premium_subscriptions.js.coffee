premium_plan_selected = ->
  $(".premium_plan_selected").click (e) ->
    e.preventDefault()
    $("#select_payment_method").removeClass("hide")
    $("#user_premium_subscription_form_premium_plan_id").val($(this).data("premium-plan-id"))

payment_method_selected = ->
  $(".user_premium_subscription_select_payment_method").click (e) ->
    e.preventDefault()
    $("#user_premium_subscription_form").removeClass("hide")
    $("#user_premium_subscription_form_payment_method_id").val($(this).data("payment-method-id"))

$(document).ready(premium_plan_selected)
$(document).on('page:load', premium_plan_selected)

$(document).ready(payment_method_selected)
$(document).on('page:load', payment_method_selected)
