class EmailNotifier < ActionMailer::Base

  default from: "InstrumentChamp <no-reply@instrumentchamp.com>"

  def welcome_message(user)
    @user = user
    mail to: @user.email
  end
  
  def password_reset(user)
    @user = user
    mail to: @user.email
  end # end password_reset action

  def user_invitation_message(user_invitation)
    @user_invitation = user_invitation
    mail to: @user_invitation.friend_email
  end

  def challenged_user_message(challenge)
    @challenge = challenge
    mail to: @challenge.challenged.email
  end

  def followed_user_message(user_follower)
    @user_follower = user_follower
    mail to: @user_follower.followed.email
  end

  def remind_challenged_user(challenge)
    @challenge = challenge
    mail to: @challenge.challenged.email
  end

  def remind_challenger_user(challenge)
    @challenge = challenge
    mail to: @challenge.challenger.email
  end

  def purchased_song_message(user_purchased_song, payment)
    @user_purchased_song = user_purchased_song
    @payment = payment
    mail to: @user_purchased_song.user.email
  end

  def user_premium_subscription_message(user_premium_subscription)
    @user_premium_subscription = user_premium_subscription
    @payment = user_premium_subscription.payment

    mail to: @user_premium_subscription.user.email
  end

  def user_premium_subscription_cancellation_message(user_premium_subscription)
    @user_premium_subscription = user_premium_subscription

    mail to: @user_premium_subscription.user.email
  end

  def user_premium_subscription_renewal_message(user_premium_subscription)
    @user_premium_subscription = user_premium_subscription
    @payment = user_premium_subscription.payment

    mail to: @user_premium_subscription.user.email
  end

  def user_premium_subscription_renewal_alert_message(user_premium_subscription)
    @user_premium_subscription = user_premium_subscription
    @payment = user_premium_subscription.payment

    mail to: @user_premium_subscription.user.email
  end
end
