class ApplicationController < ActionController::Base

  before_action :autologin_if_needed

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :signed_in?

  def signin_user(user)
    session[:user_id] = user.id
  end

  def signout_user
    session[:user_id] = nil
    reset_session
  end

  def autologin_if_needed
    if params[:autologin_user_auth_token]
      user = User.find_by_auth_token params[:autologin_user_auth_token]
      if user
        signin_user(user)
      end
    end
  end # autologin_if_needed action

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def signed_in?
    not current_user.blank?
  end

  def authorize
    session[:redirect] = root_path
    redirect_to login_path, :alert => "You have to sign in to view this page" unless signed_in?
  end

  def not_authorized
    if signed_in?
      redirect_to root_path
    end
  end

end
