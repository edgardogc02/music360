class UserInvitation < ActiveRecord::Base
  belongs_to :user

  public

  def invite
    save
    send_invitation_email
  end

  private

  def send_invitation_email
    EmailNotifier.user_invitation_message(self).deliver
  end

end
