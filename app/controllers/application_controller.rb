class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :signed_in?

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

end
