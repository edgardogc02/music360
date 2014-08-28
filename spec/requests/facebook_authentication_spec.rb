require 'spec_helper'

describe "UserOmniauthCredentials" do

  before(:each) do
    @song = create(:song)
  end

  it "should sign up user for first time with facebook account" do
    signin_with_facebook
    page.find('.alert-notice').should have_content('Welcome Facebook test user!')
    URI.parse(current_url).request_uri.should eq(home_path(welcome_tour: true))
  end

  it "should login (already signed up user) user with facebook account" do
    signin_with_facebook
    click_on "Sign out"
    signin_with_facebook
    page.find('.alert-notice').should have_content('Welcome back Facebook test user!')
    URI.parse(current_url).request_uri.should eq(home_path)
  end

  it "should have the correct values in the users table" do
    signin_with_facebook

    user = User.find_by_username('Facebook test user')
    check_user_signup_params(user, true)
    user.first_name.should eq("Facebook")
    user.last_name.should eq("test user")
  end

  it "should show welcome popup to facebook user if it signed up and had a fake user in the db" do
    signin_with_facebook
    user = User.last
    create_facebook_omniauth_credentials(user)
    UserFacebookFriends.new(user, UserFacebookAccount.new(user).top_friends).save

    click_on "People"

    click_on "Sign out"
    visit login_path

    page.should have_selector('#facebook_signin')

    mock_facebook_friend_auth_hash
    click_link "facebook_signin"

    page.find('.alert-notice').should have_content('Welcome Dick Smithberg!')
    URI.parse(current_url).request_uri.should eq(home_path(welcome_tour: true))
  end

  it "should save all facebook friends when a user signs up" do
    signin_with_facebook
    expect { FacebookFriendsWorker.perform_async(User.find_by_username('Facebook test user').id) }.to change(FacebookFriendsWorker.jobs, :size).by(1)
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
    current_path.should eq(home_path)
    click_link "Sign out"
    current_path.should eq(login_path)
    user = User.find_by_username "Facebook test user"
    user.destroy
    click_link "facebook_signin"
    current_path.should eq(login_path)
  end

end