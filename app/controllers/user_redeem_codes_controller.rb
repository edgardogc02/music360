class UserRedeemCodesController < ApplicationController

  before_action :redirect_to_current_if_not_signed_in

  layout "background_image"

  def new
    if current_user
      @user_redeem_code = current_user.user_redeem_codes.build
    end
  end

  def create
    @user_redeem_code = current_user.user_redeem_codes.build

    if @user_redeem_code.save_and_redeem(user_redeem_code_params)
      redirect_to home_path(rd: user_redeem_code_params[:code]), notice: 'The code was redeemed'
    else
      flash[:warning] = @user_redeem_code.errors.full_messages.join(', ').html_safe
      render 'new'
    end
  end

  private

  def user_redeem_code_params
    params.require(:user_redeem_code).permit(:code)
  end

end
