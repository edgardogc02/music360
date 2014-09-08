require 'spec_helper'

describe "UserGroupies" do

  before(:each) do
    public_group_privacy = create(:public_group_privacy)
    level1 = create(:level, xp: 0)
    @song = create(:song)
  end

  context "user signed in" do
    it "should see groupies to connect with" do
      visit login_path
      mock_facebook_auth_hash
      click_link "facebook_signin"

      user = User.first
      create_facebook_omniauth_credentials(user)

      UserFacebookFriends.new(user, facebook_friends).save

      visit user_groupies_path

      page.should have_content "Jennifer Yangwitz"
      page.should have_content "Dick Smithberg"
      page.should have_content "Rick Seligsteinson"
    end

    it "should have a next button" do
      login
      visit user_groupies_path
      page.should have_link "Next", href: tour_path
    end
  end

  context "user not signed in" do
    it "should not see groupies to connect with" do
      visit user_groupies_path
      current_path.should eq(login_path)
    end
  end

end
