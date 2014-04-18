class UserPasswordsController < ApplicationController

  before_action :authorize, except: [:edit, :update]
  before_action :set_user, only: [:edit, :update]
  before_action :check_security, only: [:edit, :update]

  def edit

  end

  def update
    if @user.update_attributes(user_password_params)
      redirect_to person_path(@user)
    else
      render "edit"
    end
  end

  private

  def user_password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def set_user
    @user = User.friendly.find(params[:id])
  end

  def check_security
    redirect_to root_path unless current_user == @user
  end

end