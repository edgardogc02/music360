require 'spec_helper'

describe "Users" do

  it "Sign up with correct credentials" do
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
  end

  it "Sign up with incorrect credentials" do
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

  it "sign up form if user is not signed in" do
    visit signup_path
    page.should have_selector('#new_user')
  end

  it "dont show sign up form if user is already signed in" do
    user = create(:user, username: "testuser", email: "testuser@test.com", password: "12345")
    visit login_path

    within("#login-form") do
      fill_in "username", with: 'testuser'
      fill_in "password", with: '12345'
    end

    click_on 'Sign in'

    current_path.should eq(root_path)

    visit signup_path

    page.should_not have_selector('#new_user')
  end

end
