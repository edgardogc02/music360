require 'spec_helper'

describe Challenge do

  context "Validations" do
    [:challenger_id, :song_id, :instrument].each do |attr|
      it "should validate #{attr}" do
        should validate_presence_of(attr)
      end
    end

    [:public].each do |attr|
      it "should validate #{attr}" do
        should allow_value(true, false).for(attr)
      end
    end

    it "should contain a challenged_id or a group_id" do
      challenge = build(:challenge)
      challenge.group_id = nil
      challenge.challenged_id = nil
      challenge.save
      challenge.should_not be_persisted

      challenge.challenged_id = 10
      challenge.save
      challenge.should be_persisted

      challenge.challenged_id = nil
      challenge.group_id = 10
      challenge.save
      challenge.should be_persisted
    end

    it "should not be able to create a challenge for the same challenged and song twice if it's still open" do
      challenge = create(:challenge)
      new_challenge = build(:challenge, challenger: challenge.challenger, challenged: challenge.challenged, song: challenge.song)
      new_challenge.save
      new_challenge.should_not be_persisted

      # challenger played
      challenge.score_u1 = 100
      challenge.save
      new_challenge.save
      new_challenge.should_not be_persisted

      # challenged played
      challenge.score_u1 = 0
      challenge.score_u2 = 100
      challenge.save
      new_challenge.save
      new_challenge.should_not be_persisted
    end

    it "should be able to create a new challenge for the same challenged and song it it's already played by both" do
      challenge = create(:challenge, score_u1: 100, score_u2: 200)
      new_challenge = build(:challenge, challenger: challenge.challenger, challenged: challenge.challenged, song: challenge.song)
      new_challenge.save
      new_challenge.should be_persisted
    end

    it "should not be able to challenge himself" do
      user = create(:user)
      challenge = build(:challenge, challenger: user, challenged: user)
      challenge.save
      challenge.should_not be_persisted
    end
  end

  context "Associations" do
    it "should belongs to song" do
      should belong_to(:song)
    end

    it "should belongs to group" do
      should belong_to(:group)
    end

    it "should belongs to challenger" do
      should belong_to(:challenger).class_name('User').with_foreign_key('challenger_id')
    end

    it "should belongs to challenged" do
      should belong_to(:challenged).class_name('User').with_foreign_key('challenged_id')
    end

    it "should belongs to challenger_instrument" do
      should belong_to(:challenger_instrument).class_name('Instrument').with_foreign_key('instrument_u1')
    end

    it "should belongs to challenged_instrument" do
      should belong_to(:challenged_instrument).class_name('Instrument').with_foreign_key('instrument_u2')
    end

    it "should not be able to create more than one open challenge with the same user and the same song" do
      challenger = create(:user)
      challenged = create(:user)
      song = create(:song)

      challenge = build(:challenge, song: song, challenger: challenger, challenged: challenged)
      challenge.save
      challenge.should_not be_new_record

      same_challenge = build(:challenge, song: song, challenger: challenger, challenged: challenged)
      same_challenge.save
      same_challenge.should be_new_record
    end

    it "should be able to create different challenges with different users with different songs" do
      challenger = create(:user)
      first_challenge = build(:challenge)
      first_challenge.challenger = challenger
      first_challenge.save

      first_challenge.should_not be_new_record

      second_challenge = build(:challenge)
      second_challenge.challenger = challenger
      second_challenge.save

      second_challenge.should_not be_new_record
    end

    it "should be able to create different challenges with different users with the same song" do
      challenger = create(:user)
      song = create(:song)
      first_challenge = build(:challenge, song: song, challenger: challenger)
      first_challenge.save

      first_challenge.should_not be_new_record

      second_challenge = build(:challenge, song: song, challenger: challenger)
      second_challenge.save

      second_challenge.should_not be_new_record
    end
  end

  context "Scopes" do
    it "should retrieve only public challenges" do
      public_challenge_1 = create(:challenge, public: true)
      public_challenge_2 = create(:challenge, public: true)
      private_challenge_2 = create(:challenge, public: false)
      private_challenge_2 = create(:challenge, public: false)

      Challenge.public.should eq([public_challenge_1, public_challenge_2])
    end

    it "should restrict the results to the default limit" do
      challenge1 = create(:challenge)
      challenge2 = create(:challenge)
      challenge3 = create(:challenge)
      challenge4 = create(:challenge)

      Challenge.default_limit.should eq([challenge1, challenge2, challenge3])
    end

    it "should order the results by default order" do
      challenge1 = create(:challenge, created_at: 3.hours.ago)
      challenge2 = create(:challenge, created_at: 2.hours.ago)
      challenge3 = create(:challenge, created_at: 1.hours.ago)

      Challenge.default_order.should eq([challenge3, challenge2, challenge1])
    end

    it "should return only the finished challenges" do
      challenge1 = create(:challenge)
      challenge2 = create(:challenge, score_u1: 100)
      challenge3 = create(:challenge, score_u2: 200)
      challenge4 = create(:challenge, score_u1: 4, score_u2: 20)
      challenge5 = create(:challenge, score_u1: 40, score_u2: 25)

      Challenge.finished.should eq([challenge4, challenge5])
    end

    it "should return pending challenges" do
      challenge1 = create(:challenge)
      challenge2 = create(:challenge, score_u2: 100)
      challenge3 = create(:challenge, score_u1: 100)
      challenge4 = create(:challenge, score_u1: 100, score_u2: 200)

      Challenge.pending_by_challenger.should eq([challenge1, challenge2])
      Challenge.pending_by_challenged.should eq([challenge1, challenge3])
      Challenge.pending_only_by_challenged.should eq([challenge3])
      Challenge.pending_only_by_challenger.should eq([challenge2])
    end

    it "should return challenges to be reminded" do
      challenge1 = create(:challenge)
      challenge2 = create(:challenge, score_u1: 10)
      challenge3 = create(:challenge, score_u2: 20)
      challenge4 = create(:challenge, score_u1: 30, score_u2: 40)
      challenge5 = create(:challenge, created_at: 25.hours.ago)
      challenge6 = create(:challenge, score_u1: 50, created_at: 25.hours.ago)
      challenge7 = create(:challenge, score_u2: 60, created_at: 25.hours.ago)
      challenge8 = create(:challenge, score_u1: 70, score_u2: 80, created_at: 25.hours.ago)
      challenge9 = create(:challenge, created_at: 3.days.ago)
      challenge10 = create(:challenge, score_u1: 50, created_at: 3.days.ago)
      challenge11 = create(:challenge, score_u2: 60, created_at: 3.days.ago)
      challenge12 = create(:challenge, score_u1: 70, score_u2: 80, created_at: 3.days.ago)

      Challenge.challenged_users_to_remind.should eq([challenge6])
      Challenge.challenger_users_to_remind.should eq([challenge5, challenge7])
    end

    it "should search by song title" do
      song = create(:song, title: "song 1")
      song1 = create(:song, title: "lalala")
      challenge = create(:challenge, song: song)
      challenge1 = create(:challenge, song: song)
      challenge2 = create(:challenge, song: song1)
      challenge3 = create(:challenge, song: song)

      Challenge.by_song_title("song").should eq([challenge, challenge1, challenge3])
    end

    it "should search by challenger username or email" do
      challenger = create(:user, username: "ruben")
      challenger1 = create(:user, username: "lalala")
      challenger2 = create(:user, email: "ruben@fufufu.com")
      challenger3 = create(:user, email: "jijiji@lala.com")

      challenge = create(:challenge, challenger: challenger)
      challenge1 = create(:challenge, challenger: challenger1)
      challenge2 = create(:challenge, challenger: challenger2)
      challenge3 = create(:challenge, challenger: challenger3)
      challenge4 = create(:challenge, challenger: challenger)

      Challenge.by_challenger_username_or_email("ruben").should eq([challenge, challenge2, challenge4])
    end

    it "should search by challenged username or email" do
      challenged = create(:user, username: "ruben")
      challenged1 = create(:user, username: "lalala")
      challenged2 = create(:user, email: "ruben@fufufu.com")
      challenged3 = create(:user, email: "jijiji@lala.com")

      challenge = create(:challenge, challenged: challenged)
      challenge1 = create(:challenge, challenged: challenged1)
      challenge2 = create(:challenge, challenged: challenged2)
      challenge3 = create(:challenge, challenged: challenged3)
      challenge4 = create(:challenge, challenged: challenged)

      Challenge.by_challenged_username_or_email("ruben").should eq([challenge, challenge2, challenge4])
    end

    it "should exclude challenges from results" do
      challenge = create(:challenge)
      challenge1 = create(:challenge)
      challenge2 = create(:challenge)
      challenge3 = create(:challenge)
      challenge4 = create(:challenge)

      Challenge.excludes(Challenge.last(2)).should eq([challenge, challenge1, challenge2])
    end

    it "should list only one to one challenges" do
      challenge1 = create(:challenge)
      group_challenge = create(:group_challenge)
      challenge2 = create(:challenge)

      Challenge.one_to_one.should eq([challenge1, challenge2])
    end

  end

  context "Callbacks" do
    it "should create challenge with zero scores if none is specified" do
      challenge = create(:challenge)
      challenge.should be_persisted
      challenge.score_u1.should be_zero
      challenge.score_u2.should be_zero
      challenge.end_at.to_date.should eq(1.week.from_now.to_date)
    end
  end

  context "Methods" do
    before(:each) do
      @challenge = create(:challenge)
    end

    it "should return a url for the desktop app" do
      @challenge.desktop_app_uri.should == "ic:challenge=#{@challenge.id}"
    end

    it "has_challenger_played?" do
      @challenge.has_challenger_played?.should be_false
      @challenge.score_u1 = 100
      @challenge.save
      @challenge.has_challenger_played?.should be_true
    end

    it "has_challenged_played?" do
      @challenge.has_challenged_played?.should be_false
      @challenge.score_u2 = 100
      @challenge.save
      @challenge.has_challenged_played?.should be_true
    end

    it "has_user_played?" do
      @challenge.has_user_played?(@challenge.challenged).should be_false
      @challenge.has_user_played?(@challenge.challenger).should be_false

      @challenge.score_u2 = 100
      @challenge.save
      @challenge.has_user_played?(@challenge.challenged).should be_true
      @challenge.score_u1 = 100
      @challenge.save
      @challenge.has_user_played?(@challenge.challenger).should be_true
    end

    it "is_user_challenger?" do
      @challenge.is_user_challenger?(@challenge.challenger).should be_true
      @challenge.is_user_challenger?(@challenge.challenged).should be_false
    end

    it "is_user_challenged?" do
      @challenge.is_user_challenged?(@challenge.challenger).should be_false
      @challenge.is_user_challenged?(@challenge.challenged).should be_true
    end

    it "is_user_involved?" do
      user = create(:user)
      @challenge.is_user_involved?(@challenge.challenger).should be_true
      @challenge.is_user_involved?(@challenge.challenged).should be_true
      @challenge.is_user_involved?(user).should_not be_true
    end

    it "should test union queries order by created_at desc" do
      challenger = create(:user)
      challenged = create(:user)
      challenge1 = create(:challenge, challenger: challenger, challenged: challenged, created_at: 16.hours.ago)
      challenge2 = create(:challenge, challenger: challenged, challenged: challenger, created_at: 15.hours.ago)
      challenge3 = create(:challenge, challenger: challenger, challenged: challenged, created_at: 14.hours.ago)
      challenge4 = create(:challenge, challenger: challenged, challenged: challenger, created_at: 13.hours.ago)
      challenge5 = create(:challenge, challenger: challenger, challenged: challenged, score_u1: 10, created_at: 12.hours.ago)
      challenge6 = create(:challenge, challenger: challenged, challenged: challenger, score_u1: 20, created_at: 11.hours.ago)
      challenge7 = create(:challenge, challenger: challenger, challenged: challenged, score_u1: 30, created_at: 10.hours.ago)
      challenge8 = create(:challenge, challenger: challenged, challenged: challenger, score_u1: 40, created_at: 9.hours.ago)
      challenge9 = create(:challenge, challenger: challenger, challenged: challenged, score_u2: 50, created_at: 8.hours.ago)
      challenge10 = create(:challenge, challenger: challenged, challenged: challenger, score_u2: 60, created_at: 7.hours.ago)
      challenge11 = create(:challenge, challenger: challenger, challenged: challenged, score_u2: 70, created_at: 6.hours.ago)
      challenge12 = create(:challenge, challenger: challenged, challenged: challenger, score_u2: 80, created_at: 5.hours.ago)
      challenge13 = create(:challenge, challenger: challenger, challenged: challenged, score_u1: 90, score_u2: 200, created_at: 4.hours.ago)
      challenge14 = create(:challenge, challenger: challenged, challenged: challenger, score_u1: 100, score_u2: 210, created_at: 3.hours.ago)
      challenge15 = create(:challenge, challenger: challenger, challenged: challenged, score_u1: 110, score_u2: 220, created_at: 2.hours.ago)
      challenge16 = create(:challenge, challenger: challenged, challenged: challenger, score_u1: 120, score_u2: 230, created_at: 1.hours.ago)

      # challenges for challenger
      Challenge.pending_for_user(challenger, Challenge.default_order.values).should eq([challenge12, challenge10, challenge7, challenge5])
      Challenge.not_played_by_user(challenger, Challenge.default_order.values).should eq([challenge11, challenge9, challenge8, challenge6, challenge4, challenge3, challenge2, challenge1])
      Challenge.results_for_user(challenger, Challenge.default_order.values).should eq([challenge16, challenge15, challenge14, challenge13])

      # challenges for challenged
      Challenge.pending_for_user(challenged, Challenge.default_order.values).should eq([challenge11, challenge9, challenge8, challenge6])
      Challenge.not_played_by_user(challenged, Challenge.default_order.values).should eq([challenge12, challenge10, challenge7, challenge5, challenge4, challenge3, challenge2, challenge1])
      Challenge.results_for_user(challenged, Challenge.default_order.values).should eq([challenge16, challenge15, challenge14, challenge13])
    end

    it "should test who won the challenge" do
      challenge = create(:challenge)
      challenge.challenger_won?.should be_false
      challenge.challenged_won?.should be_false

      challenge.score_u2 = 10
      challenge.save
      challenge.challenger_won?.should be_false
      challenge.challenged_won?.should be_false # the challenger still didn't play

      challenge.score_u1 = 9
      challenge.save
      challenge.challenger_won?.should be_false
      challenge.challenged_won?.should be_true

      challenge.score_u1 = 11
      challenge.save
      challenge.challenger_won?.should be_true
      challenge.challenged_won?.should be_false
    end
  end

end