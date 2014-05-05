class UsersController < ApplicationController
	before_action :authorize, except: [:create, :new]
	before_action :not_authorized, only: [:create, :new]
	before_action :set_user, only: [:show, :edit, :update, :destroy, :upload_profile_image]
  before_action :check_security, only: [:edit, :update, :destroy, :upload_profile_image]

	def index
    if params[:username_or_email]
      @users_search = User.by_username_or_email(params[:username_or_email]).page params[:page]
    else
      if current_user.has_facebook_credentials?
        @fb_top_friends = current_user.facebook_friends.limit(4)
      end
  		@regular_users = User.not_deleted.exclude(current_user.id).limit(4)
    end

    if params[:view] == 'modal'
      render 'modal', layout: false
    else
      render 'index'
    end
	end

	def show
		@challenges = Challenge.open.where(challenger: @user)
	end

	def new
	  @user = User.new
	end

	def create
	  @user = User.new(user_params)

	  if @user.sign_up(request.remote_ip)
	    signin_user(@user)
	    flash[:notice] = "Hi #{@user.username}!"
      redirect_to welcome_path
	  else
	    flash.now[:warning] = "Check the errors below and try again"
	    render "new"
	  end
	end

	def update
	  if @user.update_attributes(user_params)
      redirect_to person_path(@user), notice: "Your profile was successfully updated"
    else
      flash.now[:warning] = "Check the errors below and try again"
      render "edit"
    end
	end

	def destroy
	  @user.destroy
	  redirect_to logout_path, notice: "Your profile was successfully deleted"
	end

	def all_regular_users
    @users = User.not_deleted.exclude(current_user.id).limit(50).page params[:page]
    @title = "Challenge your Facebook Friends"
    render 'complete_list'
  end

  def all_facebook_users
    @users = current_user.facebook_friends.page params[:page]
    @title = "Challenge your InstrumentChamp Friends"
    render 'complete_list'
  end

	private

	def set_user
		@user = User.friendly.find(params[:id])
	end

	def user_params
	  params.require(:user).permit(:username, :email, :password, :password_confirmation, :imagename, :remote_imagename_url, :first_name, :last_name, :phone_number)
	end

  def check_security
    redirect_to root_path unless current_user == @user
  end
end
