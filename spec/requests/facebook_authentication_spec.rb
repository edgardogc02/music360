require 'spec_helper'

describe "UserOmniauthCredentials" do

  before(:each) do
    @song = create(:song)
  end

  it "should sign in user with facebook account" do
    signin_with_facebook
    page.find('.alert-notice').should have_content('Welcome Test User!')
  end

  it "should have the correct values in the users table" do
    signin_with_facebook

    user = User.find_by_username('Test User')
    check_user_signup_params(user, true)
    user.first_name.should eq("Test")
    user.last_name.should eq("User")
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

  def signin_with_facebook
    visit login_path

    page.should have_selector('#facebook_signin')

    mock_facebook_auth_hash
    click_link "facebook_signin"

    current_path.should eq(root_path) # successfully signed in
    page.should have_content("Test User") # user name from facebook
  end

end