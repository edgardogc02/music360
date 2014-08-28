class UserGroupsController < ApplicationController
	before_action :authorize
  before_action :set_user_group, only: [:destroy]
	before_action :check_security, only: [:destroy]

  def destroy
    group = @user_group.group

    if @user_group.destroy
      flash[:notice] = "You are no longer a member of this group"
    else
      flash[:warning] = "Something went wrong, please try again."
    end

    redirect_to group
  end

  private

  def set_user_group
    @user_group = UserGroup.find(params[:id])
  end

  def check_security
    redirect_to home_path unless current_user.user_groups.include?(@user_group)
  end

end
