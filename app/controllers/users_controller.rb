class UsersController < ApplicationController
	before_action :authorize, except: [:create, :new, :show]
	before_action :not_authorized, only: [:create, :new]
	before_action :set_user, only: [:show, :edit, :update, :destroy, :upload_profile_image, :upload_cover_image, :finish_signup]
  before_action :check_security, only: [:edit, :update, :destroy, :upload_profile_image, :upload_cover_image]
  before_action :redirect_to_current_if_not_signed_in, only: [:show]

	def index
    if params[:username_or_email]
      @users_search = SearchUsersList.new(params[:username_or_email], current_user, params[:page])
    else
      if UserFacebookAccount.new(current_user).connected?
        @fb_top_friends = ResumedFacebookFriendsList.new(current_user)
      end
  		@regular_users = ResumedPopularUsersList.new(current_user)
  		@followed_users = ResumedFollowedUsersList.new(current_user) if params[:view] != 'modal'
    end
  end

  def for_challenge
    @regular_users = ResumedMostChallengedUsersChallengeList.new(current_user, params[:song_id])
    @regular_users = ResumedPopularUsersChallengeList.new(current_user, params[:song_id]) if @regular_users.users.empty?
    @fb_top_friends = FacebookFriendsChallengeList.new(current_user, params[:song_id])
    render layout: false
	end

  def list
    @users = UsersListFactory.new(params[:view], current_user, params[:page], params[:group_id]).users_list
  end

	def show
	  if signed_in?
		  @challenges = ChallengesDecorator.decorate(Challenge.not_played_by_user(current_user, Challenge.default_order.values))
		end

		render layout: "detail"
	end

	def new
	  @user = User.new
	end

	def create
	  user_authentication = UserAuthentication.new(request, user_params)
    @user = user_authentication.user

	  if user_authentication.authenticated?
	    signin_user(@user)
	    flash[:notice] = "Hi #{@user.username}!"
	    redirect_to getting_started_path
	  else
	    flash.now[:warning] = "Check the errors below and try again"
	    render "new"
	  end
	end

	def update
	  if @user.update_attributes(user_params)
      redirect_to profile_accounts_path, notice: "Your profile was successfully updated"
    else
      flash.now[:warning] = "Check the errors below and try again"
      render "edit"
    end
	end

	def destroy
	  @user.destroy
	  redirect_to logout_path, notice: "Your profile was successfully deleted"
	end

	def finish_signup
	  if @user.update_attributes(user_params)
	    flash[:notice] = "Your email was successfully updated"
      redirect_to getting_started_path
    else
      flash[:warning] = @user.errors.full_messages.join(', ').html_safe
      redirect_to home_path add_email: true
    end
	end

	private

	def set_user
		@user = User.find(params[:id])
	end

	def user_params
	  params.require(:user).permit(:username, :email, :password, :password_confirmation, :imagename, :remote_imagename_url, :cover, :remote_cover_url, :first_name, :last_name, :phone_number)
	end

  def check_security
    redirect_to home_path unless current_user == @user
  end
end
