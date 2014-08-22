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
			if user and user.authenticate(params[:password]) and !user.deleted?
			  format.json do
			    render :json => {
			      request: request.url,
			      response: { user_access_token: user.auth_token },
			      status: { code: 200, message: "OK" }
			    }
			  end
				format.js do
          if params[:remember_me]
            signin_user(user, true)
          else
            signin_user(user)
          end
         if params[:action_modal] == 'download'
           render js: "window.location = '#{apps_path}'"
          else
            flash[:notice] = "Welcome back, #{user.username}!"
            render js: "window.location = '#{root_path}'"
          end
        end			
			else
        format.json do
          render :json => {
            request: request.url,
            response: { user_access_token: "" },
            status: { code: 401, message: "Unauthorized" }
          }
        end
  		  format.js do
          render 'session_fail'
        end
			end
		end
	end

	def destroy
	  signout_user

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
