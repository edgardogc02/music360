require 'spec_helper'

describe "UserPaidSongs" do

  describe "user is signed in" do
    before(:each) do
      @song = create(:song, cost: 0)
      @user = login
      @paid_song = create(:paid_song, cost: 14.99)
    end

    it "should display song title and artist name on buy page" do
      visit buy_user_paid_song_path(@paid_song)
      page.should have_content(@paid_song.title)
      page.should have_content("from")
      page.should have_content(@paid_song.artist.title)
    end

    it "should display the song price in the buy page" do
      visit buy_user_paid_song_path(@paid_song)
      page.should have_content(@paid_song.cost)
    end

    it "should be able to pay with credit card" do
      pending "this must be tested with js"
    end
  end

  describe "user is not signed in" do
    it "should not display new page" do
      paid_song = create(:paid_song)
      visit buy_user_paid_song_path(paid_song)
      current_path.should eq(login_path)
    end
  end

end