class RedeemCodesController < ApplicationController

  before_action :authorize

  def new
    @payment = Payment.find(params[:payment_id])
    @redeem_code = RedeemCode.new
  end

  def create
    @payment = Payment.find(params[:payment_id])
    @redeem_code = RedeemCode.new(redeem_code_params)

    respond_to do |format|
      if @redeem_code.create_code_from_payment(@payment)
        format.html do
          @redeem_code.send_emails(current_user)
          redirect_to root_path, notice: "Your redeem code is #{@redeem_code.code}"
        end
      else
        format.html do
          flash[:warning] = @redeem_code.errors.full_messages.join(', ').html_safe
          render :new
        end
      end
    end
  end

  private

  def redeem_code_params
    params.require(:redeem_code).permit(:gift_receiver)
  end

end
