module FacebookLoginMacros
  def signin_with_facebook
    public_group_privacy = create(:public_group_privacy)
    level1 = create(:level, xp: 0)

    visit login_path

    page.should have_selector('#facebook_signin')

    mock_facebook_auth_hash
    click_link "facebook_signin"

    current_path.should eq(home_path) # successfully signed in
    page.should have_content("Facebook test user") # user name from facebook
  end
end