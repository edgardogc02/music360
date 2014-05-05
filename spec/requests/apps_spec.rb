require 'spec_helper'

describe "Apps" do

  context "user signed in" do
    before(:each) do
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
  end

  context "user not signed in" do
    it "should not display index page" do
      visit apps_path
      current_path.should eq(login_path)
    end
  end
end
