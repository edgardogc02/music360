class ChallengePostCreation

  attr_accessor :challenge_post

  def initialize(challenge_post, creator_user)
    @challenge_post = challenge_post
    @creator_user = creator_user
  end

  def activity
    @activity
  end

  def save
    if @challenge_post.save
      save_activity
      true
    else
      false
    end
  end

  def save_activity
    @activity = @challenge_post.create_activity :create, owner: @creator_user, challenge_id: @challenge_post.challenge.id
  end

end