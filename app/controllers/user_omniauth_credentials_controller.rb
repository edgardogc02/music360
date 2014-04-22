class UserOmniauthCredentialsController < ApplicationController

  def create
    user = User.from_omniauth(request.env["omniauth.auth"], request.remote_ip)
    if user and !user.deleted?
      signin_user(user)
      redirect_to root_path
    else
      redirect_to login_path
    end
  end

  def failure
    redirect_to login_path, warning: "Unfortunately, you haven’t authorized Music360 to access your facebook’s information. Please try again or sign up with your email."
  end

end
