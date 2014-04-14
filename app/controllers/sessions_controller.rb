class SessionsController < ApplicationController

  before_action :not_authorized, only: [:create, :new]
  before_action :authorize, only: [:destroy]

  skip_before_action :verify_authenticity_token, if: :json_request?

	layout "sessions"

	def new
	end

	def create
		user = User.find_by_username(params[:username])

		respond_to do |format|
			if user and user.authenticate(params[:password])
			  format.json do
			    render :json => {
			      request: request.url,
			      response: { user_access_token: user.auth_token },
			      status: { code: 200, message: "OK" }
			    }
			  end
			  format.html do
  			  signin_user(user)
  				flash.notice = "Hi #{user.username}!"
				  redirect_to root_path
				end
			else
        format.json do
          render :json => {
            request: request.url,
            response: { user_access_token: "" },
            status: { code: 401, message: "Unauthorized" }
          }
        end
			  format.html do
  				flash.now.alert = "Invalid username or password"
  				redirect_to login_path
  		  end
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

  protected

  def json_request?
    request.format.json?
  end
end
