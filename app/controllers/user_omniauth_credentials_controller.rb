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
        if user.email_verified?
          if user.just_signup?
            flash[:notice] = "Welcome #{user.username}!"
            redirect_to home_path welcome_msg: true
          else
            if request.env["omniauth.params"] and request.env["omniauth.params"]["new_session_action"] == "download"
            	redirect_to apps_path
            else
              #flash[:notice] = "Welcome back #{user.username}!"
              redirect_to last_visited_page
            end
          end
        else
          redirect_to home_path add_email: true
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
      redirect_to new_user_invitation_path(tweet: params[:tweet], tweet_text: params[:tweet_text], path: params[:path], to_follow: params[:to_follow])
    else
      redirect_to home_path
    end
  end
end
