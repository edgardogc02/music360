class UserFollowersController < ApplicationController
	before_action :authorize

  def create
    @user = User.find(params[:user_follower][:user_id])
    current_user.follow(@user)
    respond_to do |format|
      format.html { redirect_to people_path }
      format.js
    end
  end

  def destroy
    user = UserFollower.find(params[:id]).followed
    current_user.unfollow(user)
    respond_to do |format|
      format.html { redirect_to people_path }
      format.js
    end
  end

end
