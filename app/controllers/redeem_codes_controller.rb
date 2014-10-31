class RedeemCodesController < ApplicationController

  before_action :authorize

  def new
    @payment = Payment.find(params[:payment_id])
    @redeem_code = RedeemCode.new
  end

  def create
    @payment = Payment.find(params[:payment_id])
    @redeem_code = RedeemCode.new

    respond_to do |format|
      if @redeem_code.create_code_from_payment(@payment)
        format.html { redirect_to root_path, notice: "Your redeem code is #{@redeem_code.code}" }
      else
        format.html do
          flash[:warning] = "Something went wrong. Please try again"
          redirect_to [@payment, @redeem_code]
        end
      end
    end
  end

  private

  def payment_form_params
    params.require(:redeem_code_form).permit(:gift_receiver)
  end

end
