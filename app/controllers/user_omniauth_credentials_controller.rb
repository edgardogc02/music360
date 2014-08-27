#encoding: utf-8
class UserOmniauthCredentialsController < ApplicationController

  def create
    if signed_in?
      update_current_user
    else
      user_authentication = UserAuthentication.new(request)
      user = user_authentication.user

      if user_authentication.authenticated?
        signin_user(user)
        if user.just_signup?
          flash[:notice] = ("Welcome #{user.username}! <br /> Please check your email for username and password for client login.").html_safe
          redirect_to root_path welcome_tour: true
        else
          flash[:notice] = "Welcome back #{user.username}!"
          redirect_to root_path
        end
      else
        redirect_to login_path
      end
    end
  end

  def failure
    redirect_to login_path, warning: "Unfortunately, you haven’t authorized InstrumentChamp to access your facebook’s information. Please try again or sign up with your email."
  end

  private

  def update_current_user
    current_user.user_omniauth_credentials.create_or_update_from_omniauth(request.env["omniauth.auth"])

    if params[:tweet]
      redirect_to new_user_invitation_path(tweet: params[:tweet], tweet_text: params[:tweet_text])
    else
      redirect_to root_path
    end
  end
end
