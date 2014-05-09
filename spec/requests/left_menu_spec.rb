require 'spec_helper'

describe "LeftMenu" do

  before(:each) do
    @song = create(:song)
  end

  describe "user is signed in" do
    it "should sign up with correct credentials" do
      user = login
      visit root_path

      page.should have_link "Home", root_path
      page.should have_link "People", people_path
      page.should have_link "Songs", songs_path
      page.should have_link "Challenges", challenges_path
      page.should have_link "Help", "https://instrumentchamp.zendesk.com"
      page.should have_link "Take the tour", tour_path
      page.should have_link "Download", apps_path
      page.should have_link "Premium", premium_path
    end
  end

  describe "user is not signed in" do
    it "should not display left menu links" do
      visit root_path
      current_path.should eq(login_path)
      page.should_not have_link "Home", root_path
    end
  end

end
