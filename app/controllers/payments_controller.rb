class PaymentsController < ApplicationController

  before_action :authorize

  def create
    @payment_form = PaymentForm.new(current_user.current_cart)

    if @payment_form.save(payment_form_params)
      flash[:notice] = "The checkout was successfully done."
      if @payment_form.payment.gift?
        redirect_to new_payment_redeem_code_path(@payment_form.payment)
      else
        redirect_to root_path
      end
    else
      flash[:warning] = "Something went wrong. Please try again."
      redirect_to @payment_form.cart
    end
  end

  def update
    payment = Payment.find(params[:id])

    if payment.update(payment_form_params)
      flash[:notice] = "The voucher was successfully generated "
    else
      flash[:warning] = cart.errors.full_messages.join(', ').html_safe
    end

    redirect_to root_path
  end

  private

  def payment_form_params
    params.require(:payment_form).permit(:cart_id, :amount, :payment_method_id, :paymill_token, :currency)
  end

end
