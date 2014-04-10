require 'spec_helper'

describe "Challenges" do

  describe "create challenges successfully" do
    before(:each) do
      @song = create(:song, cost: 0)
      @user = login
    end

    it "Create new challenge from free songs" do
      page.should have_content("Free songs")
      click_on "Free songs"
      click_on "challenge_#{@song.id}"
      current_path.should eq(new_challenge_path)

      page.should have_content("1. Song chosen")
      page.should have_content(@song.title)
      page.should have_content(@song.artist.title)
      page.should have_content("Writer")
      page.should have_content(@song.writer)
      page.should have_content("Publisher")
      page.should have_content(@song.publisher)
      page.should have_content("2. Choose friend to challenge")
      page.should have_content(@user.username)
      page.should have_content("Click to choose your opponent")
      page.should have_content("Player 2")
      page.should have_content("VS")

      challenged_user = create(:user)

      click_on "Click to choose your opponent"
      current_path.should eq(people_path)
      click_on "challenge_#{challenged_user.id}"

      current_path.should eq(new_challenge_path)
      page.should have_content(@song.title)
      page.should have_content(@user.username)
      page.should have_content(challenged_user.username)
      click_on "Start Challenge"

      current_path.should eq(yours_challenges_path)
      page.should have_content("Your challenges")
      page.should have_content(@song.title)
      page.should have_content("by")
      page.should have_content(@song.artist.title)
      page.should have_content("Created by")
      page.should have_content(@user.username)
      page.should have_content("Challenged")
      page.should have_content(challenged_user.username)
    end

    it "Create new challenge from people section" do
      challenged_user = create(:user)

      page.should have_content("People")
      click_on "People"
      click_on "challenge_#{challenged_user.id}"
      current_path.should eq(new_challenge_path)

      page.should have_content("1. Chose your song")
      page.should have_content("Click to choose your song")
      page.should have_content("2. Choose friend to challenge")
      page.should have_content(@user.username)
      page.should have_content("VS")
      page.should have_content(challenged_user.username)
      click_on "Click to choose your song"

      current_path.should eq(songs_path)
      click_on "challenge_#{@song.id}"

      current_path.should eq(new_challenge_path)
      page.should have_content("1. Song chosen")
      page.should have_content(@song.title)
      page.should have_content(@song.artist.title)
      page.should have_content("Writer")
      page.should have_content(@song.writer)
      page.should have_content("Publisher")
      page.should have_content(@song.publisher)
      page.should have_content("2. Choose friend to challenge")
      page.should have_content(@user.username)
      page.should have_content("VS")
      page.should have_content(challenged_user.username)

      click_on "Start Challenge"

      current_path.should eq(yours_challenges_path)
      page.should have_content("Your challenges")
      page.should have_content(@song.title)
      page.should have_content("by")
      page.should have_content(@song.artist.title)
      page.should have_content("Created by")
      page.should have_content(@user.username)
      page.should have_content("Challenged")
      page.should have_content(challenged_user.username)
    end
  end

  describe "cant create challenges if not signed in" do
    it "should not display challenges index if not signed in" do
      visit challenges_path
      current_path.should eq(login_path)
    end

    it "should not display challenges new if not signed in" do
      visit new_challenge_path
      current_path.should eq(login_path)
    end
  end

end
