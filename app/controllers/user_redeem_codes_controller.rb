class UserRedeemCodesController < ApplicationController

  before_action :authorize

  def new
    @user_redeem_code = current_user.user_redeem_codes.build
  end

  def create
    @user_redeem_code = current_user.user_redeem_codes.build

    if @user_redeem_code.save_and_redeem(user_redeem_code_params)
      redirect_to root_path, notice: 'The code was redeemed'
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
