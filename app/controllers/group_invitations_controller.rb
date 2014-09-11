class GroupInvitationsController < ApplicationController
	before_action :authorize
  before_action :set_group, only: [:index, :create, :pending_approval, :modal, :via_email]

  def index
    users = User.not_deleted.excludes(@group.user_ids).excludes(@group.invited_users.ids).by_xp
    if params[:username_or_email]
      users = users.by_username_or_email(params[:username_or_email])
    end
    @users_to_invite = UserInvitationDecorator.decorate_collection(users.page(params[:page]))
  end

  def modal
    @fb_top_friends = ResumedFacebookFriendsGroupInvitationList.new(current_user, @group)
    @regular_users = ResumedPopularUsersGroupInvitationsList.new(@group)
    render layout: false
  end

  def pending_approval
    @pending_invitations = @group.group_invitations.pending_approval
    render layout: "detail"
  end

  def accept
    group_invitation = GroupInvitation.find(params[:id])

    user_group = group_invitation.user.user_groups.build(group_id: group_invitation.group_id)
    user_group.save!
    group_invitation.destroy
    EmailNotifier.group_invitation_accepted(user_group).deliver
    user_group.group.assign_xp_to_owner_after_new_member_joins
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

  def via_email
    email = params[:email_group_invitation]

    unless email !~ /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
      EmailNotifier.group_invitation_via_email(current_user, @group, email).deliver
      flash[:notice] = "An invitation to join this group was send to #{email}"
    else
      flash[:warning] = "#{email} is not a valid email address"
    end

    redirect_to @group
  end

  def create
    group_invitation = @group.group_invitations.build(group_invitation_params)

    if UserGroupsManager.new(group_invitation.user).invited_to_group?(@group)
        flash[:warning] = "#{group_invitation.user.username} was already invited to this group"
    else
      group_invitation_completition = GroupInvitationCreation.new(group_invitation)

      if group_invitation_completition.save
        flash[:notice] = "#{group_invitation.user.username} was successfully invited to join #{group_invitation.group.name}"
      else
        flash[:warning] = "Please try again"
      end
    end
    redirect_to @group
  end

  private

  def group_invitation_params
    params.require(:group_invitation).permit(:user_id, :inviter_user_id)
  end

  def set_group
    @group = GroupDecorator.decorate(Group.find(params[:group_id]))
  end
end
