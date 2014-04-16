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
      user_fb_credentials.oauth_token = "CAAIAxgRfsqEBAKkFgrg2FxjCOC2lkzN56frpMSD1wTw3OSmSyhcy00GQb39z3ZCtZCzLebotv2IjTupk0vfzbFsYYzHk5WamPHWxguDEpvkGkZCJlMyH7C9wYUiZBd5PRZC5vZAR2VQgD0nr2PnkgpKj5VWYBkPRdNGbZCdwcJf09S2mZAKVyvRu"
      user_fb_credentials.save

      visit people_path
      page.should have_content "Lars Willner"
    end

    it "should not be able to perform a delete request" do
      user = create(:user)
      page.driver.submit :delete, person_path(user), {}
      user.should_not be_deleted
    end
  end

  describe "user signed in" do
    before(:each) do
      @song = create(:song)
      @user = login
    end

    it "should list all users in the people section" do
      user = create(:user)
      new_user = create(:user)

      visit people_path
      page.should have_content @user.username
      page.should have_content user.username
      page.should have_content new_user.username
      page.should have_link "challenge_#{@user.id}", href: new_challenge_path(challenged_id: @user.id)
      page.should have_link "challenge_#{user.id}", href: new_challenge_path(challenged_id: user.id)
      page.should have_link "challenge_#{new_user.id}", href: new_challenge_path(challenged_id: new_user.id)
      page.should have_link "follow_user_#{@user.id}", href: "#"
      page.should have_link "follow_user_#{user.id}", href: "#"
      page.should have_link "follow_user_#{new_user.id}", href: "#"
    end

    it "should not list the deleted users in the people section" do
      user = create(:user)
      deleted_user = create(:user)
      deleted_user.destroy

      visit people_path
      page.should have_content @user.username
      page.should have_content user.username
      page.should_not have_content deleted_user.username
      page.should have_link "challenge_#{@user.id}", href: new_challenge_path(challenged_id: @user.id)
      page.should have_link "challenge_#{user.id}", href: new_challenge_path(challenged_id: user.id)
      page.should_not have_link "challenge_#{deleted_user.id}", href: new_challenge_path(challenged_id: deleted_user.id)
    end

    it "should have a linked username in the left side bar" do
      visit root_path
      page.should have_link @user.username, href: person_path(@user.username)
    end

    it "should have a edit profile button user show page" do
      visit person_path(@user.username)
      page.should have_link "Edit profile", href: edit_person_path(@user.username)
    end

    it "should update a user profile" do
      visit edit_person_path(@user)

      fill_in 'user_username', with: 'new_username'
      fill_in 'user_email', with: 'new_username@test.com'
      click_on "Save"
      current_path.should eq(person_path("new_username"))
      page.should have_content "new_username"
      page.should have_content "new_username@test.com"
    end

    it "should display a delete profile link" do
      visit person_path(@user.username)
      page.should have_link "Delete profile", href: person_path(@user.username)
    end

    it "should delete a user" do
      visit person_path(@user.username)
      click_on "Delete profile"
      current_path.should eq(login_path)

      visit login_path
      within("#login-form") do
        fill_in 'username', with: @user.username
        fill_in 'password', with: @user.password
      end
      click_on 'sign_in'
      current_path.should eq(login_path)
    end

    it "should see upload profile image button only in his person url" do
      visit person_path(@user)
      page.should have_link "Upload profile image", upload_profile_image_person_path(@user)

      user = create(:user)
      visit person_path(user)
      page.should_not have_link "Upload profile image", upload_profile_image_person_path(user)
    end

    it "should see upload edit profile button only in his person url" do
      visit person_path(@user)
      page.should have_link "Edit profile", edit_person_path(@user)

      user = create(:user)
      visit person_path(user)
      page.should_not have_link "Edit profile", edit_person_path(user)
    end

    it "should see upload delete profile button only in his person url" do
      visit person_path(@user)
      page.should have_link "Delete profile", person_path(@user)

      user = create(:user)
      visit person_path(user)
      page.should_not have_link "Delete profile", person_path(user)
    end

    it "should not be able to edit other user profile" do
      user = create(:user)
      visit edit_person_path(user)
      current_path.should eq(root_path)
    end

    it "should not be able to delete other user profile" do
      user = create(:user)
      page.driver.submit :delete, person_path(user), {}
      current_path.should eq(root_path)
      user.should_not be_deleted
    end

    it "should not be able to update other user profile" do
      user = create(:user)
      page.driver.submit :patch, person_path(user), {}
      current_path.should eq(root_path)
    end

    it "should not be able to visit upload profile image for other user" do
      user = create(:user)
      visit upload_profile_image_person_path(user)
      current_path.should eq(root_path)
    end

  end

end
