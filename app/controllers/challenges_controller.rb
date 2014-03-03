class ChallengesController < ApplicationController
	before_action :authorize

	def index
		
	end

	def new
		if params[:user].present?
			@opponent = User.find(params[:user])
		elsif params[:song].present?
			@song = Song.find(params[:song])
		end
	end
end
