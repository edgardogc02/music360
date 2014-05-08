class FollowingController < ApplicationController
	before_action :authorize
  before_action :set_user, only: [:show]

  def show
    @users = UserDecorator.decorate_collection(@user.followed_users.page params[:page])
  end

  private

  def set_user
    @user = User.friendly.find(params[:id])
  end

end
