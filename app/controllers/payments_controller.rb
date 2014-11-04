class PaymentsController < ApplicationController

  before_action :authorize
  before_action :authorize_user, only: :show

  def show
    @payment = Payment.find(params[:id])
  end

  def create
    @payment_form = PaymentForm.new(current_user.current_cart)

    if @payment_form.save(payment_form_params)
      if @payment_form.payment.gift? or @payment_form.payment.has_premium_plan_as_gift?
        flash[:notice] = "The checkout was successfully done."
        redirect_to new_payment_redeem_code_path(@payment_form.payment)
      else
        redirect_to home_path chk: true
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

  def authorize_user
    redirect_to root_path unless current_user.payment_ids.include?(params[:id].to_i)
  end

end
