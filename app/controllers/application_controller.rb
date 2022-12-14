class ApplicationController < ActionController::Base

  before_action :autologin_if_needed, :invited_by, :save_invited_by_to_current_user

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :signed_in?, :test_domain_name?, :redirect_to_new_challenge?

  def signin_user(user, permanent=false)
    if permanent
      cookies.permanent[:auth_token] = user.auth_token
    else
      cookies[:auth_token] = user.auth_token
    end
  end

  def signout_user
    cookies.delete(:auth_token)
    reset_session
  end

  def autologin_if_needed
    if params[:autologin_user_auth_token]
      user = User.find_by_auth_token params[:autologin_user_auth_token]
      if user
        signin_user(user)
      end
    end
  end

  def invited_by
    if params[:pid] and !signed_in?
      session[:invited_by] = params[:pid]
    end
  end

  def save_invited_by_to_current_user
    if signed_in? and session[:invited_by] and !current_user.invitebyuser and session[:invited_by].to_i != current_user.id
      current_user.invitebyuser = session[:invited_by]
      current_user.save
      session[:invited_by] = nil
    end
  end

  def test_domain_name?
    request.host.include?('test-instrumentchamp')
  end

  def create_onboarding_steps(current_step_name)
    welcome_step = OnboardingProcessStep.new("Welcome", welcome_path, current_step_name == "Welcome", false)
    instrument_step = OnboardingProcessStep.new("Instrument", edit_user_instrument_path(current_user.id, next: "user_groupies"), current_step_name == "Instrument")
    groupies_step = OnboardingProcessStep.new("Groupies", user_groupies_path, current_step_name == "Groupies")

    @steps = OnboardingProcessSteps.new([welcome_step, instrument_step, groupies_step])
  end

  def last_visited_page
    session[:redirect]? session[:redirect] : root_path
  end

  private

  def current_user
    @current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
  end

  def signed_in?
    not current_user.blank?
  end

  def authorize
    session[:redirect] = home_path
    redirect_to login_path, :alert => "You have to sign in to view this page" unless signed_in?
  end

  def redirect_to_current_if_not_signed_in
    session[:redirect] = request.original_url unless signed_in?
  end

  def not_authorized
    if signed_in?
      redirect_to home_path
    end
  end

  def redirect_to_new_challenge?
    !session[:prepopulate_with_challenge_id].blank? and signed_in? and !Challenge.find(session[:prepopulate_with_challenge_id]).is_user_involved?(current_user)
  end

  def authenticate_admin_user!
    if !signed_in? or !current_user.admin?
      redirect_to home_path
    end
  end # end authenticate_admin_user! action

end
