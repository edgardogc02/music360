require 'spec_helper'

describe "Sessions" do

  describe "sign in" do
    before(:each) do
      @song = create(:song)
      public_group_privacy = create(:public_group_privacy)
      level1 = create(:level, xp: 0)
    end

    it "Sign in with correct credentials" do
      user = create(:user, username: "testuser", email: "testuser@test.com", password: "12345")

      visit login_path

      within("#login-form") do
        fill_in 'username', with: 'testuser'
        fill_in 'password', with: '12345'
      end

      click_on 'sign_in'

      page.find('.alert-notice').should have_content('Welcome back, testuser!')
      current_path.should eq(home_path)
      page.should have_content("testuser")
    end

    it "Sign in with incorrect credentials" do
      visit login_path

      within("#login-form") do
        fill_in 'username', with: 'testuser'
        fill_in 'password', with: ''
      end

      click_on 'sign_in'

#      page.find('.alert-warning').should have_content('Invalid username or password') # TODO
      current_path.should eq(login_path)
      page.should have_selector('#login-form')
    end

    it "should not be able to signout" do
      visit logout_path
      current_path.should eq(login_path)
    end
  end

  describe "user already signed in" do
    before(:each) do
      @song = create(:song, cost: 0)
      @user = login
    end

    it "should not be able to login" do
      visit login_path

      current_path.should eq(home_path)
    end

    it "should sign out successfully" do
      visit people_path

      click_on 'sign_out'
      current_path.should eq(login_path)
    end
  end

end
