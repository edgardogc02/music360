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
    before(:each) do
      @user = login
    end

    it "should list user followers" do
      non_follower = create(:user)
      follower = create(:user)

      follower.follow(@user)

      visit user_follower_path(@user)
      page.should have_content follower.username
      page.should_not have_content non_follower.username
    end

    it "should email followed user" do
      followed_user = create(:user)
      @user.follow(followed_user)
      last_email.to.should include(followed_user.email)
    end

    it "should not email followed user if it's a fake facebook user" do
      pending
    end

    context "user has a new follower" do
      it "should give 100 MP points to the followed user" do
        followed = create(:user)
        xp_points = followed.xp
        @user.follow(followed)
        followed.reload
        followed.xp.should eq(xp_points+100)
      end

      it "should give 50 MP points to the follower user" do
        followed = create(:user)
        xp_points = @user.xp
        @user.follow(followed)
        @user.reload
        @user.xp.should eq(xp_points+50)
      end
    end
  end
end