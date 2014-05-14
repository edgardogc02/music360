#encoding: utf-8
class UserOmniauthCredentialsController < ApplicationController

  def create
    user = User.from_omniauth(request)

    if user and !user.deleted?
      signin_user(user)
      flash[:notice] = "Welcome #{user.username}!"
      redirect_to root_path welcome_tour: true
    else
      redirect_to login_path
    end
  end

  def failure
    redirect_to login_path, warning: "Unfortunately, you haven’t authorized InstrumentChamp to access your facebook’s information. Please try again or sign up with your email."
  end

end
