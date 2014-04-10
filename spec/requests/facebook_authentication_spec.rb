require 'spec_helper'

describe "UserOmniauthCredentials" do

  before(:each) do
    @song = create(:song)
  end

  it "can sign in user with facebook account" do
    visit login_path

    page.should have_selector('#facebook_signin')

    mock_facebook_auth_hash
    click_link "facebook_signin"

    current_path.should eq(root_path) # successfully signed in
    page.should have_content("Test User") # user name from facebook
  end

  it "can handle authentication error" do
    OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
    visit login_path
    page.should have_selector('#facebook_signin')
    click_link "facebook_signin"
    current_path.should eq(login_path) # redirected to login path
  end

end