require 'spec_helper'

describe "UserFollowers" do

  before(:each) do
    @song = create(:song)
  end

  context "user not signed in" do
    it "should not list user followers" do
      user = create(:user)
      visit user_follower_path(user)
      current_path.should eq(login_path)
    end
  end

  context "user signed in" do
    it "should list user followers" do
      user = login
      non_follower = create(:user)
      follower = create(:user)

      follower.follow(user)

      visit user_follower_path(user)
      page.should have_content follower.username
      page.should_not have_content non_follower.username
    end
  end
end