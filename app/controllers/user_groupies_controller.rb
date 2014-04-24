class UserGroupiesController < ApplicationController
	before_action :authorize

	def index
#    begin
      if current_user.has_facebook_credentials?
        fb_top_friends = current_user.facebook_top_friends(10)

        UserFacebookFriends.new(current_user, fb_top_friends).save

        @user_groupies = current_user.groupies_to_connect_with
      end
#    rescue
#    end
	end

end
