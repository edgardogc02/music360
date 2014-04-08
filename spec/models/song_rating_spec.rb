require 'spec_helper'

describe SongRating do

  context "Validations" do
    [:user_id, :song_id, :rating].each do |attr|
      it "should validate presence of #{attr}" do
        should validate_presence_of(attr)
      end
    end
  end

  context "Associations" do
    it "should have belongs to user and song" do
      should belong_to(:user)
      should belong_to(:song)
    end
  end

end