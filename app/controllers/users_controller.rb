class UsersController < ApplicationController
	before_action :authorize, except: [:create]
	before_action :set_user, only: [:show, :edit, :update, :destroy]

	def index
		@users = User.all
	end

	def show
	end

	private

	def set_user
		@user = User.find(params[:id])
	end

	def user_params
	  params.require(:user).permit(:username, :email, :level, :password, :password_confirmation)
	end
end
