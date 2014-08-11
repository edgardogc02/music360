require 'spec_helper'

describe "UserPassword" do

  before(:each) do
    @song = create(:song)
  end

  describe "user is signed in" do
    before(:each) do
      @user = login
    end

    it "should have a change password button in the user page" do
      visit profile_accounts_path
      page.should have_link "Change password", href: edit_user_password_path(@user)
    end

    it "should have a change password button in other user's page" do
      new_user = create(:user)
      visit person_path(new_user)
      page.should_not have_link "Change password", href: edit_user_password_path(new_user)
    end

    it "should be able to edit his password" do
      visit edit_user_password_path(@user)
      fill_in 'user_password', with: 'new password'
      fill_in 'user_password_confirmation', with: 'new password'
      click_on "Save"
      current_path.should eq(person_path(@user))

      page.find('.alert-notice').should have_content('Your password was successfully updated')

      @user.reload
      @user.authenticate('new password').should be_true
    end

    it "should not be able to see edit password view for another user" do
      new_user = create(:user)
      visit edit_user_password_path(new_user)
      current_path.should eq(root_path)
    end

    it "should not be able to update other user's password" do
      new_user = create(:user)
      page.driver.submit :patch, user_password_path(new_user), {user: {password: "12345", password_confirmation: "12345"}, id: new_user.username }
      current_path.should eq(root_path)
    end
  end

  describe "user is not signed in" do
    before(:each) do
      visit logout_path # make sure the user is not signed in
    end
    it "should not show edit password view" do
      user = create(:user)
      visit edit_user_password_path(user)
      current_path.should eq(login_path)
    end

    it "should not let a user update a password" do
      new_user = create(:user)
      page.driver.submit :patch, user_password_path(new_user), {user: {password: "12345", password_confirmation: "12345"}, id: new_user.username }
      current_path.should eq(login_path)
    end
  end

end
