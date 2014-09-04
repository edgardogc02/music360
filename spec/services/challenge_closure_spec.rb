require 'spec_helper'

describe "ChallengeClosure" do

  context "close" do

    it 'should close a challenge group' do
      challenge = create(:challenge)
      ChallengeClosure.new(challenge).close
      challenge.open.should_not be_true
    end

    context 'save activity feed' do
      it 'should save an activity feed that the challenge has finished' do
        challenge = create(:challenge)
        ChallengeClosure.new(challenge).close

        activity = PublicActivity::Activity.where(challenge_id: challenge.id).order('created_at DESC').last

        activity.trackable.should eq(challenge)
        activity.key.should eq('challenge.challenge_closed')
      end
    end

    it 'notify_users_about_results' do
      challenge = create(:challenge)
      song_score1 = create(:song_score, challenge: challenge, score: 100)
      song_score2 = create(:song_score, challenge: challenge, score: 500)

      ChallengeClosure.new(challenge).close

      ActionMailer::Base.deliveries.first.to.should include(song_score2.user.email)
      ActionMailer::Base.deliveries.second.to.should include(song_score1.user.email)

      ActionMailer::Base.deliveries.first.body.raw_source.should include("You got #{song_score2.score} points and finished nr. 1")
      ActionMailer::Base.deliveries.second.body.raw_source.should include("You got #{song_score1.score} points and finished nr. 2")
    end
  end

end