require 'spec_helper'

describe UserPurchasedSong do

  context "Validations" do
    [:user_id, :song_id].each do |attr|
      it "should have validate presence of #{attr}" do
        should validate_presence_of(attr)
      end
    end

    it "should validate user_id and song_id are unique" do
      should validate_uniqueness_of(:song_id).scoped_to(:user_id)
    end
  end

  context "Associations" do
    [:user, :song, :payment].each do |rel|
      it "should belongs to #{rel}" do
        should belong_to(rel)
      end
    end
  end

end
