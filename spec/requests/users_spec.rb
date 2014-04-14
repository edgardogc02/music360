require 'spec_helper'

describe "Users" do

  before(:each) do
    @song = create(:song)
  end

  describe "user not signed in" do
    it "should sign up with correct credentials" do
      visit signup_path

      within("#new_user") do
        fill_in 'user[username]', with: 'testuser'
        fill_in 'user[email]', with: 'testuser@test.com'
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
      end

      click_on 'Sign up'

      current_path.should eq(root_path)
  #    last_email.to.should include('testuser@test.com')
      page.should have_content('testuser')
    end

    it "should sign up with incorrect credentials" do
      visit signup_path

      within("#new_user") do
        fill_in 'user[username]', with: 'testuser'
        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
      end

      click_on 'Sign up'

      current_path.should eq(people_path)
      page.should have_selector('#new_user')
    end

    it "should display sign up form if user is not signed in" do
      visit signup_path
      page.should have_selector('#new_user')
    end

    it "should not show sign up form if user is already signed in" do
      user = create(:user, username: "testuser", email: "testuser@test.com", password: "12345")
      visit login_path

      within("#login-form") do
        fill_in "username", with: 'testuser'
        fill_in "password", with: '12345'
      end

      click_on 'sign_in'

      current_path.should eq(root_path)

      visit signup_path

      page.should_not have_selector('#new_user')
    end

    it "should display top facebook friends on the people section" do
      visit login_path

      mock_facebook_auth_hash
      click_link "facebook_signin"

      # update the oauth token so it can perform a facebook call
      user_fb_credentials = User.first.facebook_credentials
      user_fb_credentials.oauth_token = "CAAIAxgRfsqEBAFosZASVUxqsyvfMmCpQoHyHPbtCCYnqDVY0JHERbkKd4teib6PmoQ1biuyTTHQsshDIBePHFW7MPRRs66THGyvqNQN5ggBrkvDjunghHdv0DT1mwlG5QMM53WrPLtjbpyZBYLexjdLgmr7aTix5n321A2nwHH7Q0LEzJK"
      user_fb_credentials.save

      visit people_path
      page.should have_content "Lars Willner"
    end
  end

  describe "user signed in" do
    before(:each) do
      @song = create(:song, cost: 0)
      @user = login
    end

    it "should not be able to login" do
      visit login_path

      current_path.should eq(root_path)
    end
  end

end
