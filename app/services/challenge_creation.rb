class ChallengeCreation

  attr_accessor :challenge

  def initialize(challenge)
    @challenge = challenge
  end

  def save
    if challenge.save
      challenge.challenger.follow(challenge.challenged) if !challenge.challenger.following?(challenge.challenged)
      notify_challenged_user
      true
    else
      false
    end
  end

  private

  def notify_challenged_user
    if challenge.challenged.can_receive_messages?
      EmailNotifier.challenged_user_message(challenge).deliver
    end
  end

end