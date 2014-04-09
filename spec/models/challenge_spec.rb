require 'spec_helper'

describe Challenge do

  context "Validations" do
    [:challenger_id, :challenged_id, :song_id, :instrument].each do |attr|
      it "should validate #{attr}" do
        should validate_presence_of(attr)
      end
    end

    [:public, :finished].each do |attr|
      it "should validate #{attr}" do
        should allow_value(true, false).for(attr)
      end
    end
  end

  context "Associations" do
    it "should belongs to song" do
      should belong_to(:song)
    end

    it "should belongs to challenger" do
      should belong_to(:challenger).class_name('User').with_foreign_key('challenger_id')
    end

    it "should belongs to challenged" do
      should belong_to(:challenged).class_name('User').with_foreign_key('challenged_id')
    end

    it "should not be able to create more than one open challenge with the same user and the same song" do
      challenger = create(:user)
      challenged = create(:user)
      song = create(:song)

      challenge = build(:challenge, finished: false, song: song, challenger: challenger, challenged: challenged)
      challenge.save
      challenge.should_not be_new_record

      same_challenge = build(:challenge, finished: false, song: song, challenger: challenger, challenged: challenged)
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

    it "should be able to create a new challenge with the same user for the same song if the challenge is already finished" do
      challenger = create(:user)
      challenged = create(:user)
      song = create(:song)
      first_challenge = build(:challenge, finished: true, song: song, challenger: challenger, challenged: challenged)
      first_challenge.save
      first_challenge.should_not be_new_record

      second_challenge = build(:challenge, finished: false, song: song, challenger: challenger, challenged: challenged)
      second_challenge.save

      second_challenge.should_not be_new_record

      third_challenge = build(:challenge, finished: false, song: song, challenger: challenger, challenged: challenged)
      third_challenge.save

      third_challenge.should be_new_record
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

    it "should retrieve only open challenges" do
      open_challenge_1 = create(:challenge, finished: false)
      open_challenge_2 = create(:challenge, finished: false)
      finished_challenge_2 = create(:challenge, finished: true)
      finished_challenge_2 = create(:challenge, finished: true)

      Challenge.open.should eq([open_challenge_1, open_challenge_2])
    end
  end

end