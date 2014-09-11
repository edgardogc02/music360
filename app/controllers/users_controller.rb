class UsersController < ApplicationController
	before_action :authorize, except: [:create, :new]
	before_action :not_authorized, only: [:create, :new]
	before_action :set_user, only: [:show, :edit, :update, :destroy, :upload_profile_image, :upload_cover_image]
  before_action :check_security, only: [:edit, :update, :destroy, :upload_profile_image, :upload_cover_image]

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
    @fb_top_friends = FacebookFriendsChallengeList.new(current_user, params[:song_id])
    @regular_users = ResumedPopularUsersChallengeList.new(current_user, params[:song_id])
    render layout: false
	end

  def list
    @users = UsersListFactory.new(params[:view], current_user, params[:page], params[:group_id]).users_list
  end

	def show
		@challenges = ChallengesDecorator.decorate(Challenge.not_played_by_user(current_user, Challenge.default_order.values))

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
	    redirect_to home_path welcome_msg: true
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
