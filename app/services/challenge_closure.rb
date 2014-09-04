class ChallengeClosure

  attr_accessor :challenge

  def initialize(challenge)
    @challenge = challenge
  end

  def close
    notify_users_about_results
    challenge.close
    save_activity
  end

  private

  def save_activity
    challenge.create_activity :challenge_closed, challenge_id: challenge.id
  end

  def notify_users_about_results
    challenge.song_scores.by_score.each_with_index do |song_score, i|
      EmailNotifier.challenge_final_position(song_score, i+1).deliver
    end
  end

end