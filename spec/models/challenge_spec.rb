require 'spec_helper'

describe Challenge do

  context "Validations" do
    [:user1, :user2, :song_id, :instrument].each do |attr|
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
      should belong_to(:challenger).class_name('User').with_foreign_key('user1')
    end

    it "should belongs to challenged" do
      should belong_to(:challenged).class_name('User').with_foreign_key('user2')
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