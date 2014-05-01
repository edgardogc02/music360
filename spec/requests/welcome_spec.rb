require 'spec_helper'

describe "Users" do

  before(:each) do
    @song = create(:song)
  end

  context "user signed in" do
    before(:each) do
      @user = login
    end

    it "should be able to see the welcome page" do
      visit welcome_path
      page.should have_content "Welcome #{@user.username}"
    end

    it "should have a continue button to select the user instrument" do
      visit welcome_path
      page.should have_link "Next", href: edit_user_instrument_path(@user.id, next: "user_groupies")
    end
  end

  context "user not signed in" do
    it "should not be able to see the welcome page" do
      visit welcome_path
      current_path.should eq(login_path)
    end
  end

end
