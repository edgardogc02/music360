require 'spec_helper'

describe UserPaidSong do

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

end
