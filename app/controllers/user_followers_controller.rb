class UserFollowersController < ApplicationController
	before_action :authorize

  def create
    @followed_user = User.find(params[:user_follower][:user_id])
    current_user.follow(@followed_user)
    respond_to do |format|
      format.html { redirect_to people_path, notice: "You are now following #{@followed_user.username}" }
      format.js
    end
  end

  def destroy
    @followed_user = UserFollower.find(params[:id]).followed
    current_user.unfollow(@followed_user)
    respond_to do |format|
      format.html { redirect_to people_path, notice: "You are no longer following #{@followed_user.username}" }
      format.js
    end
  end

end
