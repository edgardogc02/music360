class RedeemCodesController < ApplicationController

  before_action :authorize

  def new
    @payment = Payment.find(params[:payment_id])
    @redeem_code = RedeemCode.new
    @redeem_code.create_code_from_payment(@payment)
  end

  def send_code
    #@payment = Payment.find(params[:payment_id])
    @redeem_code = RedeemCode.find(params[:redeem_code])
    @redeem_code.gift_receiver = params[:gift_receiver]

    respond_to do |format|
      if @redeem_code.send_emails(params[:gift_receiver])
        format.html do
          redirect_to root_path, notice: "Your redeem code is #{@redeem_code.code}"
        end
      else
        format.html do
          redirect_to root_path, notice: "#{@redeem_code.errors.inspect}"
        end
      end
    end
  end

  private

  def redeem_code_params
    params.require(:redeem_code).permit(:gift_receiver).permit(:send_to)
  end

end
