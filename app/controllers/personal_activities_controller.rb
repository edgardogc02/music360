class PersonalActivitiesController < ApplicationController
	before_action :authorize

	def index
    @activity_feeds = UserPersonalActivityFeed.new(current_user).feeds.page(params[:page]).per(10)
    respond_to do |format|
      format.html
      format.js
    end
  end

end
