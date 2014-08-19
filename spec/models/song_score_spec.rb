require 'spec_helper'

describe SongScore do

  context "Associations" do
    [:user, :song].each do |assoc|
      it "should belongs to #{assoc}" do
        should belong_to(assoc)
      end
    end
  end

  context "Scope" do
    it "should order results by best_scores" do
      user = create(:user)
      user1 = create(:user)
      challenge = create(:challenge)
      song = create(:song)
      instrument = create(:instrument)
      instrument1 = create(:instrument)

      create(:song_score, user: user, song: song, challenge: challenge, score: 10, instrument: instrument)
      create(:song_score, user: user, song: song, challenge: challenge, score: 1, instrument: instrument)

      create(:song_score, user: user, song: song, challenge: challenge, score: 200, instrument: instrument1)
      create(:song_score, user: user, song: song, challenge: challenge, score: 2200, instrument: instrument1)

      create(:song_score, user: user1, song: song, challenge: challenge, score: 90, instrument: instrument)

      create(:song_score, user: user1, song: song, challenge: challenge, score: 80, instrument: instrument1)

      SongScore.best_scores.map{|r| r.max_score }.should eq([2200, 90, 80, 10])
      SongScore.best_scores.map{|r| r.user_id }.should eq([user.id, user1.id, user1.id, user.id])
    end
  end

end
