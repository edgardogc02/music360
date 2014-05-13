class EmailNotifier < ActionMailer::Base

  default from: "InstrumentChamp <no-reply@instrumentchamp.com>"

  def welcome_message(user)
    @user = user
    @host = "https://www.instrumentchamp.com" # TODO:
    mail to: @user.email
  end

  def user_invitation_message(user_invitation)
    @user_invitation = user_invitation
    @host = "https://www.instrumentchamp.com"
    mail to: @user_invitation.friend_email
  end

  def challenged_user_message(challenge)
    @challenge = challenge
    @host = "https://www.instrumentchamp.com"
    mail to: @challenge.challenged.email
  end

  def followed_user_message(user_follower)
    @user_follower = user_follower
    @host = "https://www.instrumentchamp.com"
    mail to: @user_follower.followed.email
  end

end
