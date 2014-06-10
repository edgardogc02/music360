select_credit_card_payment = ->
  $("#select_credit_card_payment").click (e) ->
    $("#credit_card_payment_form_fields").removeClass("hide") # show() is not working
    $("#select_payment_type").hide()
    $("#submit_buy_song_form").removeClass("hide")
    e.preventDefault()

select_payment_type = ->
  $(".select_payment_type").click (e) ->
    $("#user_purchased_song_form_payment_type_id").val($(this).data("payment-type-id"))

$(document).ready(select_credit_card_payment)
$(document).on('page:load', select_credit_card_payment)

$(document).ready(select_payment_type)
$(document).on('page:load', select_payment_type)

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
    $("#submit_buy_song_form").removeAttr "disabled"
  else
    $(".payment-errors").css "display", "none"
    $(".payment-errors").text ""
    form = $("#new_user_purchased_song_form")

    form.append "<input type='hidden' name='user_purchased_song_form[paymill_token]' value='" + result.token + "'/>"
    form.get(0).submit()
  $(".submit-button").removeAttr "disabled"
  return

root = exports ? this

root.submit_credit_card_payment = ->
  $("#new_user_purchased_song_form").submit (event) ->

    $("#submit_buy_song_form").attr "disabled", "disabled"
    if false is paymill.validateCardNumber($("#user_purchased_song_form_card_number").val())
      $(".payment-errors").text "That card number is invalid"
      $(".payment-errors").css "display", "inline-block"
      $("#submit_buy_song_form").removeAttr "disabled"
    if false is paymill.validateExpiry($("#user_purchased_song_form_card_expiry_date_2i").val(), $("#user_purchased_song_form_card_expiry_date_1i").val())
      $(".payment-errors").text "Invalid expiration date"
      $(".payment-errors").css "display", "inline-block"
      $("#submit_buy_song_form").removeAttr "disabled"
    if $("#user_purchased_song_form_card_holdername").val() is ""
      $(".payment-errors").text "The card holdername is invalid"
      $(".payment-errors").css "display", "inline-block"
      $("#submit_buy_song_form").removeAttr "disabled"
    params =
      amount_int: parseInt($("#user_purchased_song_form_payment_amount").val() * 100) # E.g. "15" for 0.15 Eur
      currency: "EUR" # ISO 4217 e.g. "EUR"
      number: $("#user_purchased_song_form_card_number").val()
      exp_month: $("#user_purchased_song_form_card_expiry_date_2i").val()
      exp_year: $("#user_purchased_song_form_card_expiry_date_1i").val()
      cvc: $("#user_purchased_song_form_card_cvc").val()
      cardholder: $("#user_purchased_song_form_card_holdername").val()

    paymill.createToken params, paymill_response_handler
    false

  return
