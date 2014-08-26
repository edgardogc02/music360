class GroupChallengeCreation

  attr_accessor :challenge

  def initialize(challenge)
    @challenge = challenge
  end

  def save
    if challenge.save
      save_activity
      true
    else
      false
    end
  end

  private

  def save_activity
    @challenge.create_activity :group_challenge_create, owner: @challenge.challenger, group_id: @challenge.group.id, challenge_id: @challenge.id
  end

end