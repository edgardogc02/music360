class GroupChallengeClosure

  attr_accessor :challenge

  def initialize(challenge)
    @challenge = challenge
  end

  def close
    assign_extra_xp_points_to_winner
    assign_extra_xp_points_to_challenge_creator
    notify_users_about_results
    challenge.close
  end

  private

  def assign_extra_xp_points_to_winner
  end

  def assign_extra_xp_points_to_challenge_creator
  end

  def notify_users_about_results
  end

end