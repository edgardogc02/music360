class UsersController < ApplicationController
	before_action :authorize, except: [:create]
	before_action :set_user, only: [:show, :edit, :update, :destroy]

	def index
		@categories = PeopleCategory.all
		@users = params[:type].present? ? User.where(people_category_id: params[:type]) : User.all
	end

	def show
	end

	private

	def set_user
		@user = User.friendly.find(params[:id])
	end

	def user_params
	  params.require(:user).permit(:username, :email, :level, :password, :password_confirmation)
	end
end
