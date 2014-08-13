class GroupInvitationsController < ApplicationController
	before_action :authorize
  before_action :set_group

  def index
    @users_to_invite = UserDecorator.decorate_collection(User.not_deleted.excludes(@group.user_ids))
  end

  def create
    group_invitation = @group.group_invitations.build(group_invitation_params)

    group_invitation_completition = GroupInvitationCreation.new(group_invitation)

    if group_invitation_completition.save
      flash[:notice] = "#{group_invitation.user.username} was successfully invited to join #{group_invitation.group.name}"
    else
      flash[:warning] = "Please try again"
    end
    redirect_to group_group_invitations_path(@group)
  end

  private

  def group_invitation_params
    params.require(:group_invitation).permit(:user_id)
  end

  def set_group
    @group = Group.find(params[:group_id])
  end
end