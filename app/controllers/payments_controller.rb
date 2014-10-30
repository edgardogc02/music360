class PaymentsController < ApplicationController

  before_action :authorize

  def create
    @payment_form = PaymentForm.new(current_user.current_cart)

    if @payment_form.save(payment_form_params)
      flash[:notice] = "The checkout was successfully done."
      redirect_to root_path
    else
      flash[:warning] = "Something went wrong. Please try again."
      redirect_to @payment_form.cart
    end

  end

  private

  def payment_form_params
    params.require(:payment_form).permit(:cart_id, :amount, :payment_method_id, :paymill_token, :currency)
  end

end
