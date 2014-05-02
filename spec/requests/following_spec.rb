require 'spec_helper'

describe "Following" do

  before(:each) do
    @song = create(:song)
  end

  context "user not signed in" do
    it "should not list following page" do
      user = create(:user)
      visit following_path(user)
      current_path.should eq(login_path)
    end
  end

  context "user signed in" do
    it "should list following page" do
      user = login
      followed_user = create(:user)
      non_followed_user = create(:user)

      user.follow(followed_user)

      visit following_path(user)
      page.should have_content followed_user.username
      page.should_not have_content non_followed_user.username
    end
  end
end