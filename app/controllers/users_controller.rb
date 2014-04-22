class UsersController < ApplicationController
	before_action :authorize, except: [:create, :new]
	before_action :not_authorized, only: [:create, :new]
	before_action :set_user, only: [:show, :edit, :update, :destroy, :upload_profile_image]
  before_action :check_security, only: [:edit, :update, :destroy, :upload_profile_image]

	def index
    begin
      if current_user.has_facebook_credentials?
        @fb_top_friends = current_user.facebook_top_friends(10)

        current_user.save_facebook_friends(@fb_top_friends)
      end

  		@categories = UserCategory.all
  		@users = User.not_deleted.page params[:page]
  		@users = @users.where(people_category_id: params[:type]) if params[:type].present?
    rescue
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
      redirect_to root_path
	  else
	    render "new"
	  end
	end

	def update
	  if @user.update_attributes(user_params)
      redirect_to person_path(@user)
    else
      render "edit"
    end
	end

	def destroy
	  @user.destroy
	  redirect_to logout_path
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
