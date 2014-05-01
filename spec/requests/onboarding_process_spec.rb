require 'spec_helper'

describe "OnboardingProcess" do

  before(:each) do
    @song = create(:song)
  end

  context "sign in user" do
    before(:each) do
      @user = login
    end

    it "should display header with links in the welcome page" do
      visit welcome_path
      has_header_with_links
    end

    it "should display header with links in the user instruments page" do
      visit edit_user_instrument_path(@user.id, next: "user_groupies")
      has_header_with_links
    end

    it "should display header with links in the user groupies page" do
      visit user_groupies_path
      has_header_with_links
    end

    def has_header_with_links
      page.should have_link "Welcome", href: welcome_path
      page.should have_link "Instrument", href: edit_user_instrument_path(@user.id, next: "user_groupies")
      page.should have_link "Groupies", href: user_groupies_path
    end
  end

  context "not sign in user" do
  end

end
