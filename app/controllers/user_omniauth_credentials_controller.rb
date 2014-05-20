#encoding: utf-8
class UserOmniauthCredentialsController < ApplicationController

  def create
    user = User.from_omniauth(request)

    if params[:tweet]
      redirect_to new_user_invitation_path(tweet: params[:tweet], tweet_text: params[:tweet_text])
    else
      if user and !user.deleted?
        signin_user(user)
        if user.just_signup?
          flash[:notice] = "Welcome #{user.username}!"
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

end
