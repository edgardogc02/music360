require 'spec_helper'

describe "UserOmniauthCredentials" do

  before(:each) do
    @song = create(:song)
  end

  it "should sign in user with facebook account" do
    visit login_path

    page.should have_selector('#facebook_signin')

    mock_facebook_auth_hash
    click_link "facebook_signin"

    current_path.should eq(root_path) # successfully signed in
    page.should have_content("Test User") # user name from facebook

    user = User.find_by_username 'Test User'
    user.username.should eq("Test User")
    user.email.should eq("test@test.com")
    user.first_name.should eq("Test")
    user.last_name.should eq("User")
    user.confirmed.should_not be_blank
  end

  it "should handle authentication error" do
    OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
    visit login_path
    page.should have_selector('#facebook_signin')
    click_link "facebook_signin"
    current_path.should eq(login_path) # redirected to login path
  end

  it "should not sign in if user is deleted" do
    visit login_path
    mock_facebook_auth_hash
    click_link "facebook_signin"
    current_path.should eq(root_path)
    click_link "Sign out"
    current_path.should eq(login_path)
    user = User.find_by_username "Test User"
    user.destroy
    click_link "facebook_signin"
    current_path.should eq(login_path)
  end

end