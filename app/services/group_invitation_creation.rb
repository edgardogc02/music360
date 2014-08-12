class GroupInvitationCreation

  attr_accessor :group_invitation

  def initialize(group_invitation)
    @group_invitation = group_invitation
  end

  def save
    if group_invitation.save
      notify_invited_user
      true
    else
      false
    end
  end

  private

  def notify_invited_user
    if group_invitation.user.can_receive_messages?
      EmailNotifier.group_invitation_message(group_invitation).deliver
    end
  end

end