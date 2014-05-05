class UserGroupiesController < ApplicationController
	before_action :authorize

	def index
    @steps = @steps = create_onboarding_steps("Groupies")
    begin
      if current_user.has_facebook_credentials?
        @user_groupies = current_user.groupies_to_connect_with.limit(4)
      end
    rescue
    end
	end

  def create
    @followed_user = User.find(params[:user_follower][:user_id])
    current_user.follow(@followed_user)
    respond_to do |format|
      format.html { redirect_to people_path }
      format.js { render 'update.js' }
    end
  end

  def destroy
    @followed_user = UserFollower.find(params[:id]).followed
    current_user.unfollow(@followed_user)
    respond_to do |format|
      format.html { redirect_to people_path }
      format.js { render 'update.js' }
    end
  end

end
