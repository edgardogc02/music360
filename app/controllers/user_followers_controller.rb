class UserFollowersController < ApplicationController
	before_action :authorize
  before_action :set_user, only: [:show]

  def show
    @user_followers = UserDecorator.decorate_collection(@user.followers.page params[:page])
  end

  def create
    @followed_user = User.find(params[:user_follower][:user_id])
    current_user.follow(@followed_user)
    respond_to do |format|
      format.html { redirect_to following_path(current_user), notice: "You are now following #{@followed_user.username}" }
      format.js
    end
  end

  def create_multiple
    #return render text: "#{params.inspect}"
    params[:follow_ids].each do |followed_user_id|
      followed_user = current_user.inverse_user_followers.create(user_id: followed_user_id)
    end
    redirect_to getting_started_music_challenges_path
  end

  def destroy
    @followed_user = UserFollower.find(params[:id]).followed
    current_user.unfollow(@followed_user)
    respond_to do |format|
      format.html { redirect_to following_path(current_user), notice: "You are no longer following #{@followed_user.username}" }
      format.js
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

end
