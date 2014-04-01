class UsersController < ApplicationController
	before_action :authorize, except: [:create, :new]
	before_action :not_authorized, only: [:create, :new]
	before_action :set_user, only: [:show, :edit, :update, :destroy]

	def index
		@categories = PeopleCategory.all
		@users = params[:type].present? ? User.where(people_category_id: params[:type]) : User.all
	end

	def show
		@challenges = Challenge.open.where(owner: @user)
	end

	def new
	  @user = User.new
	end

	def create
	  @user = User.new(user_params)

	  if @user.save
	    signin_user(@user)
      redirect_to root_path
	  else
	    render "new"
	  end
	end

	private

	def set_user
		@user = User.friendly.find(params[:id])
	end

	def user_params
	  params.require(:user).permit(:username, :email, :password, :password_confirmation)
	end
end
