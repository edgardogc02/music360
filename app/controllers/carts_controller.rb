class CartsController < ApplicationController

  before_action :authorize

  def show
    @cart = current_user.current_cart
    @payment_form = PaymentForm.new(@cart)
  end

  def update
    cart = Cart.find(params[:id])

    if cart.update(cart_params)
      flash[:notice] = "Your cart was successfully modified"
    else
      flash[:warning] = cart.errors.full_messages.join(', ').html_safe
    end

    redirect_to cart
  end

  private

  def cart_params
    params.require(:cart).permit(:discount_code_code, :mark_as_gift)
  end

end
