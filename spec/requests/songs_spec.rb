require 'spec_helper'

describe "Songs" do

  describe "user is signed in" do
    before(:each) do
      @song = create(:song, cost: 0)
      @user = login
    end

    it "should display song view" do
      new_song = create(:song)
      visit songs_path
      click_on new_song.title
      page.should have_content new_song.title
      page.should have_content new_song.artist.title
      page.should have_link "Quick start song", href: new_song.desktop_app_uri
      page.should have_link "Create challenge", href: new_challenge_path(song_id: new_song.id)
    end

    it "should display songs" do
      new_free_song = create(:song, cost: 0)
      paid_song = create(:song, cost: 1)

      page.should have_content "Songs"
      click_on "Songs"

      page.should have_content @song.title
      page.should have_content @song.artist.title

      page.should have_link @song.title, href: artist_song_path(@song.artist, @song)
      page.should have_link @song.artist.title, href: artist_path(@song.artist)

      page.should have_link new_free_song.title, href: artist_song_path(new_free_song.artist, new_free_song)
      page.should have_link new_free_song.artist.title, href: artist_path(new_free_song.artist)

      page.should have_content new_free_song.title
      page.should have_content new_free_song.artist.title

      page.should have_content "Play"
      page.should have_content "Challenge"

      page.should have_selector "#challenge_#{@song.id}"
      page.should have_selector "#challenge_#{new_free_song.id}"

      page.should have_link "Play", href: @song.desktop_app_uri
      page.should have_link "Play", href: new_free_song.desktop_app_uri

      page.should have_link "Challenge", href: new_challenge_path(song_id: @song.id)
      page.should have_link "Challenge", href: new_challenge_path(song_id: new_free_song.id)

      page.should_not have_content paid_song.title
      page.should_not have_content paid_song.artist.title
    end

    it "should list free songs order by popularity" do
      most_popular_free_song = create(:song)
      popular_free_song = create(:song)
      unpopular_free_song = create(:song)
      unrated_free_song = create(:song)

      most_popular_paid_song = create(:song, cost: 1)
      popular_paid_song = create(:song, cost: 5.0)
      unpopular_paid_song = create(:song, cost: 4.5)
      unrated_paid_song = create(:song, cost: 7.0)

      create(:song_rating, song: most_popular_free_song, rating: 5)
      create(:song_rating, song: most_popular_free_song, rating: 4)

      create(:song_rating, song: popular_free_song, rating: 5)
      create(:song_rating, song: popular_free_song, rating: 3)

      create(:song_rating, song: unpopular_free_song, rating: 1)

      create(:song_rating, song: most_popular_paid_song, rating: 6)
      create(:song_rating, song: most_popular_paid_song, rating: 5)

      create(:song_rating, song: popular_paid_song, rating: 3)
      create(:song_rating, song: popular_paid_song, rating: 2)

      create(:song_rating, song: unpopular_paid_song, rating: 1)

      visit free_songs_path

      page.should have_content most_popular_free_song.title
      page.should have_content popular_free_song.title
      page.should have_content unpopular_free_song.title
      page.should have_content @song.title
      page.should have_content unrated_free_song.title

      page.should_not have_content most_popular_paid_song.title
      page.should_not have_content popular_paid_song.title
      page.should_not have_content unpopular_paid_song.title
      page.should_not have_content unrated_paid_song.title

      page.body.index(most_popular_free_song.title).should < page.body.index(popular_free_song.title)
      page.body.index(popular_free_song.title).should < page.body.index(unpopular_free_song.title)
      page.body.index(unpopular_free_song.title).should < page.body.index(@song.title)
      page.body.index(@song.title).should < page.body.index(unrated_free_song.title)
    end

    it "should open the challenge page when clicking challenge from a song view" do
      new_song = create(:song)
      visit songs_path
      page.should have_link new_song.title, href: artist_song_path(new_song.artist, new_song)
      click_on new_song.title

      current_path.should eq(artist_song_path(new_song.artist, new_song))
      click_on "Create challenge"
      URI.parse(current_url).request_uri.should eq(new_challenge_path(song_id: new_song.id))
    end
  end

  describe "user is not signed in" do
    it "should not display free songs if user is not signed up" do
      visit free_songs_path
      current_path.should eq(login_path)
    end
  end

end