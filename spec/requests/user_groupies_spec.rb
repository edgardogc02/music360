require 'spec_helper'

describe "UserGroupies" do

  before(:each) do
    @song = create(:song)
  end

  describe "user signed in" do

    it "should see groupies to connect with" do
      visit login_path
      mock_facebook_auth_hash
      click_link "facebook_signin"

      user = User.first
      create_facebook_omniauth_credentials(user)

      visit user_groupies_path

      page.should have_content "Ashutosh Morwal"
      page.should have_content "Lars Willner"
      page.should have_content "Magnus Willner"
    end
  end

  describe "user not signed in" do

    it "should not see groupies to connect with" do
      visit user_groupies_path
      current_path.should eq(login_path)
    end
  end

end
