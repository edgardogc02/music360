require 'spec_helper'

describe "Challenges" do

  describe "create challenges successfully" do
    before(:each) do
      @song = create(:song, cost: 0)
      @user = login
    end

    it "Create new challenge from songs" do
      click_on "Songs"
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

      page.should have_xpath("//meta")
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

      page.should have_content("Friends")
      click_on "Friends"
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

    it "Your challenges should have a start challenge link" do
      private_challenge = create(:challenge, public: false, challenger: @user)
      visit yours_challenges_path
      page.should have_content private_challenge.song.title
      page.should have_link "challenge_start_#{private_challenge.id}", href: private_challenge.desktop_app_uri
    end

    it "your challenges should not list challenges from others" do
      your_private_challenge = create(:challenge, public: false, challenger: @user)
      other_private_challenge = create(:challenge, public: false)

      visit yours_challenges_path
      page.should have_content your_private_challenge.song.title
      page.should have_link "challenge_start_#{your_private_challenge.id}", href: your_private_challenge.desktop_app_uri

      page.should_not have_content other_private_challenge.song.title
    end

    it "should create challenge with out any params (first chose opponent and then song) " do
      challenged_user = create(:user)
      visit new_challenge_path

      page.should have_content "1. Chose your song"
      click_on "Click to choose your opponent"
      current_path.should eq(people_path)
      click_on "challenge_#{challenged_user.id}"

      current_path.should eq(new_challenge_path)
      click_on "Click to choose your song"
      current_path.should eq(songs_path)
      click_on "challenge_#{@song.id}"
      click_on "Start Challenge"

      current_path.should eq(yours_challenges_path)
      page.should have_content("Your challenges")
      page.should have_content(@song.title)
      page.should have_content(challenged_user.username)
    end

    it "should create challenge with out any params (first chose song and then opponent) " do
      challenged_user = create(:user)
      visit new_challenge_path

      page.should have_content "1. Chose your song"
      click_on "Click to choose your song"
      current_path.should eq(songs_path)
      click_on "challenge_#{@song.id}"
      current_path.should eq(new_challenge_path)

      click_on "Click to choose your opponent"
      current_path.should eq(people_path)
      click_on "challenge_#{challenged_user.id}"

      click_on "Start Challenge"

      current_path.should eq(yours_challenges_path)
      page.should have_content("Your challenges")
      page.should have_content(@song.title)
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
