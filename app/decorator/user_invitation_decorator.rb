class UserInvitationDecorator < UserDecorator

  delegate_all

  def invite_to_group?
    true
  end

end