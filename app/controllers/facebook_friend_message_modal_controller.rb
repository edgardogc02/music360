class FacebookFriendMessageModalController < ApplicationController
	before_action :authorize

  def close
    render layout: false
  end
end
