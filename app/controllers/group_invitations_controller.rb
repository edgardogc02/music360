class GroupInvitationsController < ApplicationController
	before_action :authorize
  before_action :set_group, only: [:index, :create, :pending_approval]

  def index
    users = User.not_deleted.excludes(@group.user_ids)
    if params[:username_or_email]
      users = users.by_username_or_email(params[:username_or_email])
    end
    @users_to_invite = UserDecorator.decorate_collection(users.page(params[:page]))
  end

  def pending_approval
    @pending_invitations = @group.group_invitations.pending_approval
  end

  def accept
    group_invitation = GroupInvitation.find(params[:id])

    user_group = group_invitation.user.user_groups.build(group_id: group_invitation.group_id)
    user_group.save!
    group_invitation.destroy
    EmailNotifier.group_invitation_accepted(user_group).deliver
    redirect_to pending_approval_group_group_invitations_path(user_group.group), notice: "#{user_group.user.username} is a new member of #{user_group.group.name}"
  end

  def reject
    group_invitation = GroupInvitation.find(params[:id])
    group = group_invitation.group
    user = group_invitation.user
    EmailNotifier.group_invitation_rejected(user, group).deliver
    group_invitation.destroy
    flash[:warning] = "You have rejected the membership to #{user.username}"
    redirect_to pending_approval_group_group_invitations_path(group)
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
    params.require(:group_invitation).permit(:user_id, :inviter_user_id)
  end

  def set_group
    @group = Group.find(params[:group_id])
  end
end
