class RedeemCodesController < ApplicationController

  before_action :authorize

  def new
    @payment = Payment.find(params[:payment_id])
    @redeem_code = RedeemCode.new
    @redeem_code.create_code_from_payment(@payment)
    redirect_to [@payment, @redeem_code]
  end

  def show
    @payment = Payment.find(params[:payment_id])
    @redeem_code = RedeemCode.find(params[:id])
  end

  def update
    @payment = Payment.find(params[:payment_id])
    @redeem_code = RedeemCode.find(params[:id])

    respond_to do |format|
      if @redeem_code.update_attributes(redeem_code_params)
        format.html do
          @redeem_code.send_emails(current_user)
          redirect_to root_path, notice: "The redeem code was successfully sent"
        end
      else
        format.html do
          flash[:warning] = @redeem_code.errors.full_messages.join(', ').html_safe
          render :show
        end
      end
    end
  end

  private

  def redeem_code_params
    params.require(:redeem_code).permit(:gift_receiver_username, :gift_receiver_email)
  end

end
