get_error_text = (error_key) ->
  switch error_key
    when "internal_server_error" then "Communication with PSP failed"
    when "invalid_public_key" then "Invalid Public Key"
    when "invalid_payment_data" then "Not permitted for this method of payment, credit card type, currency or country"
    when "unknown_error" then "Unknown Error"
    when "3ds_cancelled" then "Password Entry of 3-D Secure password was cancelled by the user"
    when "field_invalid_card_number" then "Missing or invalid creditcard number"
    when "field_invalid_card_exp_year" then "Missing or invalid expiry year"
    when "field_invalid_card_exp_month" then "Missing or invalid expiry month"
    when "field_invalid_card_exp" then "Card is no longer valid or has expired"
    when "field_invalid_card_cvc" then "Invalid checking number"
    when "field_invalid_card_holder" then "Invalid cardholder"
    when "field_invalid_amount_int" then "Invalid or missing amount for 3-D Secure"
    when "field_invalid_amount" then "Invalid or missing amount for 3-D Secure"
    when "field_invalid_currency" then "Invalid or missing currency code for 3-D Secure"
    else "Unknown Error"

paymill_response_handler = (error, result) ->
  if error
    $(".payment-errors").text get_error_text error.apierror
    $(".payment-errors").css "display", "inline-block"
    $("#submit_purchase_form").removeAttr "disabled"
  else
    $(".payment-errors").css "display", "none"
    $(".payment-errors").text ""
    form = $("#user_purchase_form")
    $("#paymill_token").val(result.token)
    form.get(0).submit()
  $(".submit-button").removeAttr "disabled"
  return

root = exports ? this

root.submit_credit_card_payment = ->
  $("#user_purchase_form").submit (event) ->

    $("#submit_purchase_form").attr "disabled", "disabled"
    if false is paymill.validateCardNumber($("#credit_card_number").val())
      $(".payment-errors").text "That card number is invalid"
      $(".payment-errors").css "display", "inline-block"
      $("#submit_purchase_form").removeAttr "disabled"
    if false is paymill.validateExpiry($(".credit_card_expiry_date").first().val(), $(".credit_card_expiry_date").last().val())
      $(".payment-errors").text "Invalid expiration date"
      $(".payment-errors").css "display", "inline-block"
      $("#submit_purchase_form").removeAttr "disabled"
    if $("#credit_card_holdername").val() is ""
      $(".payment-errors").text "The card holdername is invalid"
      $(".payment-errors").css "display", "inline-block"
      $("#submit_purchase_form").removeAttr "disabled"
    params =
      amount_int: parseInt($("#amount").val() * 100) # E.g. "15" for 0.15 Eur
      currency: "EUR" # ISO 4217 e.g. "EUR"
      number: $("#credit_card_number").val()
      exp_month: $(".credit_card_expiry_date").first().val()
      exp_year: $(".credit_card_expiry_date").last().val()
      cvc: $("#credit_card_cvc").val()
      cardholder: $("#credit_card_holdername").val()

    paymill.createToken params, paymill_response_handler
    false

  return