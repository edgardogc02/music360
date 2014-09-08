require 'spec_helper'

describe "Apps" do

  context "user signed in" do
    before(:each) do
      @public_group_privacy = create(:public_group_privacy)
      @level1 = create(:level, xp: 0)
      @user = login
    end

    it "should display index page with links for download" do
      pending "links are added with js"
      visit apps_path
      page.should have_link "http://blog.instrumentchamp.com/thanks-for-download-osx/"
      page.should have_link "http://blog.instrumentchamp.com/thanks-for-download-win/"
    end

    it "should let the user inform us that he already installed the app if he didn't do that before" do
      @user.installed_desktop_app.should_not be_true
      visit apps_path
      page.should have_link "I already installed the app", href: apps_path(installed: true)
      click_on "I already installed the app"
      @user.reload
      current_path.should eq(apps_path)
      @user.installed_desktop_app.should be_true
    end

    it "should not show link to mark desktop app as installed if user already did this" do
      @user.already_installed_desktop_app
      @user.reload
      visit apps_path
      page.should_not have_link "I already installed the app", href: apps_path(installed: true)
    end

    it "should save the user selected song" do
      song = create(:song)
      visit songs_path
      first("#play_song_#{song.title.squish.downcase.tr(" ","_")}").click

      @user.reload
      @user.first_song_id.should eq(song.id)
    end

    it "should save the user selected song" do
      challenge = create(:challenge, challenger: @user)
      visit challenges_path
      click_on "Start challenge"

      @user.reload
      @user.first_challenge_id.should eq(challenge.id)
    end
  end

  context "user not signed in" do
    it "should not display index page" do
      pending "this was changed (now all users can see this page)"
      visit apps_path
      current_path.should eq(login_path)
    end
  end
end
