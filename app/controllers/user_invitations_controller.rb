class UserInvitationsController < ApplicationController
	before_action :authorize, except: [:create, :new]

	def new
  end
end
