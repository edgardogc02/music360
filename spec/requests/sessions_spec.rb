require 'spec_helper'

describe "Sessions" do

  before(:each) do
    @song = create(:song)
  end

  it "Sign in with correct credentials" do
    user = create(:user, username: "testuser", email: "testuser@test.com", password: "12345")

    visit login_path

    within("#login-form") do
      fill_in 'username', with: 'testuser'
      fill_in 'password', with: '12345'
    end

    click_on 'Sign in'

    current_path.should eq(root_path)
    page.should have_content("testuser")
  end

  it "Sign in with incorrect credentials" do
    visit login_path

    within("#login-form") do
      fill_in 'username', with: 'testuser'
      fill_in 'password', with: ''
    end

    click_on 'Sign in'

    current_path.should eq(login_path)
    page.should have_selector('#login-form')
  end

end
