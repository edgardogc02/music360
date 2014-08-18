require 'spec_helper'

describe "Challenges" do

  context "user is sign in" do
    before(:each) do
      @song = create(:song, cost: 0)
      @user = login
    end

    it "Create new challenge from songs" do
      click_on "Songs"
      first("#challenge_#{@song.id}").click
      current_path.should eq(new_challenge_path)

      page.should have_content(@song.title)
      page.should have_content(@song.artist.title)
      page.should have_content("Choose friend to challenge")
      page.should have_content(@user.username)
      page.should have_content("Choose your opponent")
      page.should have_content("VS")

      challenged_user = create(:user)

      click_on "Choose your opponent"
      current_path.should eq(for_challenge_people_path)
      click_on "challenge_#{challenged_user.id}"

      current_path.should eq(new_challenge_path)

      page.should have_content(@song.title)
      page.should have_content(@user.username)
      page.should have_content(challenged_user.username)

      click_on "Create Challenge"

      page.find('.alert-notice').should have_content('The challenge was successfully created')
      current_path.should eq(yours_challenges_path)

      #page.should have_xpath("//meta")
      page.should have_content("Your challenges")
      page.should have_content(@song.title)
#      page.should have_content("by")
      page.should have_content(@song.artist.title)
#      page.should have_content("Created by")
      page.should have_content(@user.username)
#      page.should have_content("Challenged")
      page.should have_content(challenged_user.username)
    end

    it "Create new challenge from people section" do
      challenged_user = create(:user)

      page.should have_content("People")
      click_on "People"
      click_on "challenge_#{challenged_user.id}"
      current_path.should eq(new_challenge_path)

      page.should have_content("1. Choose the challenge")
      page.should have_content("2. Choose friend to challenge")
      page.should have_content(@user.username)
      page.should have_content("VS")
      page.should have_content(challenged_user.username)

      click_on "challenge_#{@song.id}"

      current_path.should eq(new_challenge_path)
      page.should have_content("1. Challenge chosen")
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

      click_on "Create Challenge"

      page.find('.alert-notice').should have_content('The challenge was successfully created')
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

    it "should create a challenge with correct values" do
      challenged_user = create(:user)
      click_on "People"
      click_on "challenge_#{challenged_user.id}"
      click_on "challenge_#{@song.id}"
      click_on "Create Challenge"

      challenge = Challenge.last
      challenge.challenger.should eq(@user)
      challenge.challenged.should eq(challenged_user)
      challenge.song.should eq(@song)
      challenge.instrument.should be_zero
      challenge.public.should_not be_true
      challenge.score_u1.should be_zero
      challenge.score_u2.should be_zero
    end

    it "should create a new challenge and follow the user" do
      challenge = create_challenge
      @user.following?(challenge.challenged).should be_true
    end

    context "email notification" do
      it "should send an email to the challenged user" do
        challenge = create_challenge
        last_email.to.should include(challenge.challenged.email)
      end

      it "should not send an email to the challenged user if it's a fake facebook user" do
        challenge = create_challenge(create(:user, email: "1234123@fakeuser.com")) # the challenged user should be a fake facebook user
        last_email.should be_nil
      end
    end

    it "should not contain play when selecting a song" do
      visit new_challenge_path
      page.should_not have_link "Play", @song.decorate.play_url
    end

    it "should create challenge with correct data" do
      challenged_user = create(:user)

      click_on "People"
      click_on "challenge_#{challenged_user.id}"
      click_on "challenge_#{@song.id}"
      click_on "Create Challenge"

      challenge = Challenge.last
      challenge.challenger.should eq(@user)
      challenge.challenged.should eq(challenged_user)
      challenge.song.should eq(@song)
      challenge.instrument.should eq(0)
      challenge.score_u1.should eq(0)
      challenge.score_u2.should eq(0)
    end

    context "user did not installed the app yet" do
      it "should redirect the user to the app page if they want to start the challenge" do
        private_challenge = create(:challenge, public: false, challenger: @user)
        visit challenges_path
        page.should have_link "Start challenge", href: apps_path + "?challenge_id=#{private_challenge.id}"
      end

      it "should be redirected to the apps page if challenge is public and user wants to start the challenge" do
        public_challenge = create(:challenge, public: true, challenger: @user)
        visit challenges_path
        page.should have_link "Start challenge", href: apps_path + "?challenge_id=#{public_challenge.id}"
      end
    end

    it "should display points and winner if both players have played" do
      challenge = create(:challenge, public: true, challenged: @user)
      challenge.score_u1 = 100
      challenge.score_u2 = 500
      challenge.save

      visit challenges_path

#      page.should have_content "#{challenge.challenger.username}"
      page.should have_content "100 points"
#      page.should have_content "#{challenge.challenged.username}"
      page.should have_content "500 points"
      page.should have_content "Winner"
    end

    context "user installed the desktop app" do
      before(:each) do
        @user.already_installed_desktop_app
        @user.reload
      end

      it "should have start challenge links if challenge is private and user is involved" do
        private_challenge = create(:challenge, public: false, challenger: @user)
        visit challenges_path
        page.should have_link "Start challenge", href: private_challenge.decorate.start_challenge_url

        new_private_challenge = create(:challenge, public: false, challenged: @user)
        visit challenges_path
        page.should have_link "Start challenge", href: new_private_challenge.decorate.start_challenge_url
      end

      it "should have start challenge links if challenge public" do
        public_challenge = create(:challenge, public: true, challenger: @user)
        visit challenges_path
        page.should have_content public_challenge.song.title
        page.should have_link "Start challenge", href: public_challenge.decorate.start_challenge_url
      end
    end

    it "should not have start challenge links if challenge is private and user is not involved" do
      new_private_challenge = create(:challenge, public: false)
      visit challenges_path
      page.should_not have_link "challenge_start_#{new_private_challenge.id}", href: new_private_challenge.decorate.start_challenge_url
    end

    it "your challenges should not list challenges from others" do
      your_private_challenge = create(:challenge, public: false, challenger: @user)
      other_private_challenge = create(:challenge, public: false)

      visit yours_challenges_path
      page.should have_content your_private_challenge.song.title
      page.should have_link "challenge_start_#{your_private_challenge.id}", href: your_private_challenge.decorate.start_challenge_url

      page.should_not have_content other_private_challenge.song.title
    end

    it "should create challenge with out any params (first chose opponent and then song) " do
      challenged_user = create(:user)
      visit new_challenge_path

      page.should have_content "1. Choose the challenge"
      click_on "Choose your opponent"
      click_on "challenge_#{challenged_user.id}"

      current_path.should eq(new_challenge_path)
      click_on "challenge_#{@song.id}"
      click_on "Create Challenge"

      page.find('.alert-notice').should have_content('The challenge was successfully created')
      current_path.should eq(yours_challenges_path)
      page.should have_content("Your challenges")
      page.should have_content(@song.title)
      page.should have_content(challenged_user.username)
    end

    it "should create challenge from the challenge new page" do
      challenged_user = create(:user)
      visit new_challenge_path

      page.should have_content "1. Choose the challenge"
      click_on "challenge_#{@song.id}"
      current_path.should eq(new_challenge_path)

      click_on "Choose your opponent"
      click_on "challenge_#{challenged_user.id}"

      click_on "Create Challenge"

      page.find('.alert-notice').should have_content('The challenge was successfully created')
      current_path.should eq(yours_challenges_path)
      page.should have_content("Your challenges")
      page.should have_content(@song.title)
      page.should have_content(challenged_user.username)
    end

    it "should have new challenge button in challenges index" do
      visit challenges_path
      page.should have_link "Create a new challenge", new_challenge_path
    end

    it "should display 3 challenges categories in the index page" do
      my_challenge = create(:challenge, challenger: @user)
      pending_challenge = create(:challenge, challenger: @user, score_u1: 25)
      result_challenge = create(:challenge, challenger: @user, score_u1: 10, score_u2: 20)

      visit challenges_path
      page.should have_content "My challenges"
      page.should have_content "Pending"
      page.should have_content "Results"

      page.should have_link "View all", href: list_challenges_path(view: "my_challenges")
      page.should have_link "View all", href: list_challenges_path(view: "pending")
      page.should have_link "View all", href: list_challenges_path(view: "results")

      page.should have_link "Start challenge", href: my_challenge.decorate.start_challenge_url
      page.should have_content "#{pending_challenge.challenger.username}: #{pending_challenge.score_u1} points"
      page.should have_content "#{pending_challenge.challenged.username}: #{pending_challenge.score_u2} points"

      page.should have_content "#{result_challenge.challenger.username}: #{result_challenge.score_u1} points"
      page.should have_content "#{result_challenge.challenged.username}: #{result_challenge.score_u2} points Winner"
    end

    it "should display start challenge only to the involved users" do
      challenged = create(:user, username: "challenged_user", password: "12345")
      my_challenge = create(:challenge, challenger: @user, challenged: challenged)

      visit challenge_path(my_challenge)
      page.should have_link "Start challenge", href: my_challenge.decorate.start_challenge_url

      click_on "Sign out"

      within("#login-form") do
        fill_in "username", with: 'challenged_user'
        fill_in "password", with: '12345'
      end
      click_on 'sign_in'

      visit challenge_path(my_challenge)
      page.should have_link "Start challenge", href: my_challenge.decorate.start_challenge_url

      click_on "Sign out"

      signin_with_facebook
      visit challenge_path(my_challenge)
      page.should_not have_link "Create challenge", href: my_challenge.decorate.start_challenge_url
    end

    it "should include the user auth_token in the start challenge link" do
      my_challenge = create(:challenge, challenger: @user)
      visit challenge_path(my_challenge)
      page.should_not have_link "Create challenge", href: my_challenge.desktop_app_uri + "&user_auth_token=" + @user.auth_token
    end

    it "should display the instrument the user used in the challenge" do
      guitar = create(:instrument, name: "guitar")
      piano = create(:instrument, name: "piano")
      challenge1 = create(:challenge, challenger: @user, score_u1: 10, instrument_u1: guitar.id)
      challenge2 = create(:challenge, challenger: @user, score_u2: 20, instrument_u2: piano.id)
      challenge3 = create(:challenge, challenger: @user, score_u1: 30, score_u2: 40, instrument_u1: guitar.id, instrument_u2: piano.id)

      visit challenge_path(challenge1)
      page.should have_content("#{@user.username}: 10 points on guitar")

      visit challenge_path(challenge2)
      page.should have_content("#{@user.username}: 0 points")
      page.should have_content("#{challenge2.challenged.username}: 20 points on piano")

      visit challenge_path(challenge3)
      page.should have_content("#{@user.username}: 30 points on guitar")
      page.should have_content("#{challenge3.challenged.username}: 40 points on piano")
    end

    it "should not show the user created songs in the new challenge page" do
      user_created_song = create(:song, user_created: 1)

      visit new_challenge_path
      page.should have_content(@song.title)
      page.should_not have_content(user_created_song.title)
    end

    it "should increment the challenges counter for involved users when challenge is created" do
      challenged_user = create(:user)
      visit new_challenge_path

      @user.challenges_count.should eq(0)
      challenged_user.challenges_count.should eq(0)

      click_on "Choose your opponent"
      click_on "challenge_#{challenged_user.id}"
      click_on "challenge_#{@song.id}"
      click_on "Create Challenge"

      @user.reload
      challenged_user.reload

      @user.challenges_count.should eq(1)
      challenged_user.challenges_count.should eq(1)
    end
  end

  context "user not signed in" do
    it "should not display challenges new if not signed in" do
      visit new_challenge_path
      current_path.should eq(login_path)
    end

    it "should not show create new challenge button in challenges index" do
      visit challenges_path
      page.should_not have_link "New challenge", new_challenge_path
    end

    it "should not display start challenge button in challenge show page" do
      pending
    end
  end

  def create_challenge(challenged_user=nil)
    challenged_user = create(:user) if challenged_user.nil?
    visit people_path
    click_on "challenge_#{challenged_user.id}"
    click_on "challenge_#{@song.id}"
    click_on "Create Challenge"
    Challenge.last
  end

end
