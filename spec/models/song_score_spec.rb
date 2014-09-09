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

    it 'should order by score' do
      song_score = create(:song_score, score: 1000)
      song_score1 = create(:song_score, score: 100)
      song_score2 = create(:song_score, score: 500)

      SongScore.by_score.should eq([song_score, song_score2, song_score1])
    end

    it 'should return the highest scores limited by limit' do
      challenge = create(:challenge)
      song_score = create(:song_score, challenge: challenge, score: 10)
      song_score1 = create(:song_score, challenge: challenge, score: 5)
      song_score2 = create(:song_score, challenge: challenge, score: 7)

      SongScore.highest_scores(2).should eq([song_score, song_score2])
    end
  end

  context 'method' do
    it 'should return the highest score' do
      song_score = create(:song_score, score: 1000)
      song_score1 = create(:song_score, score: 100)
      song_score2 = create(:song_score, score: 500)

      SongScore.highest_score.should eq(song_score)
    end

    it 'should return the position in the world' do
      song = create(:song)
      song1 = create(:song)

      song_score1 = create(:song_score, song: song, score: 1000)
      song_score2 = create(:song_score, song: song, score: 100)
      song_score3 = create(:song_score, song: song, score: 500)

      song_score4 = create(:song_score, song: song1, score: 500)
      song_score5 = create(:song_score, song: song1, score: 50000)

      song_score1.position_in_the_world.should eq(1)
      song_score3.position_in_the_world.should eq(2)
      song_score2.position_in_the_world.should eq(3)

      song_score5.position_in_the_world.should eq(1)
      song_score4.position_in_the_world.should eq(2)
    end
  end

end
