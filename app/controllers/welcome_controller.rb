class WelcomeController < ApplicationController
	before_action :authorize

	def index
	  create_onboarding_steps("Welcome")
	end

end
