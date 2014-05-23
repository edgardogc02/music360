class FacebookFriendMessageModalController < ApplicationController
	before_action :authorize

  def new
    @challenge = Challenge.find(params[:challenge_id])
  end

  def close
    render layout: false
  end
end
