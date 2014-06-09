premium_plan_selected = ->
  $(".premium_plan_selected").click (e) ->
    e.preventDefault()
    $("#select_payment_type").removeClass("hide")
    $("#user_premium_subscription_form_premium_plan_id").val($(this).data("premium-plan-id"))

payment_type_selected = ->
  $(".user_premium_subscription_select_payment_type").click (e) ->
    e.preventDefault()
    $("#user_premium_subscription_form").removeClass("hide")
    $("#user_premium_subscription_form_payment_type_id").val($(this).data("payment-type-id"))

$(document).ready(premium_plan_selected)
$(document).on('page:load', premium_plan_selected)

$(document).ready(payment_type_selected)
$(document).on('page:load', payment_type_selected)
