class UserInvitationDecorator < UserDecorator

  delegate_all

  def invite_to_group?
    true
  end

  def display_challenge_button?
    false
  end

end