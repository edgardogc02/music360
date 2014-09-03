class ChallengeCreation

  attr_accessor :challenge

  def initialize(challenge)
    @challenge = challenge
  end

  def save
    if challenge.save
      challenge.challenger.follow(challenge.challenged) if !challenge.challenger.following?(challenge.challenged)
      notify_challenged_user
      increment_challenger_challenges
      increment_challenged_challenges
      save_activity
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

  def save_activity
    @challenge.create_activity :challenge_create, owner: @challenge.challenger, challenge_id: @challenge.id
  end

  def increment_challenger_challenges
    challenge.challenger.increment_challenges_count
  end

  def increment_challenged_challenges
    challenge.challenged.increment_challenges_count
  end

end