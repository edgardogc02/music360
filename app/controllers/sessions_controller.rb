class SessionsController < ApplicationController
	layout "sessions"

	def new
	end

	def create
		user = User.find_by_username(params[:username])

		respond_to do |format|
			if user and user.authenticate(params[:password])
				session[:user_id] = user.id
				flash.notice = "Hi #{user.username}!"
				format.html { redirect_to root_path }
			else
				flash.now.alert = "Invalid username or password"
				format.html { redirect_to login_path }
			end
		end
	end

	def destroy
		session[:user_id] = nil

		if session[:redirect].blank?
			redirect_to login_path, notice: "You have been signed out"
		else
			redirect_to session[:redirect], notice: "You have been signed out"
		end
	end
end
