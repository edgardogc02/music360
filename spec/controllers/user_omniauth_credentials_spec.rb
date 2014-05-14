require 'spec_helper'

describe UserOmniauthCredentialsController do

  describe "success facebook omniauth signups" do
    before do
      mock_facebook_auth_hash
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]
    end

    it "create a user from facebook credentials" do
      check_conditions(1, 1) # check user and user omniauth credentials records are created
    end

    it "create only user omniauth credentials from facebook" do
      create(:user, username: "Test User", email: "test@test.com") # that user with the email already exists in our db
      check_conditions(0, 1) # check just user omniauth credentials are created
    end

    it "create new user when username is already taken" do
      pending "TODO"
      create(:user, username: "Test User", email: "test1@test.com") # that user with the email already exists in our db
      check_conditions(1, 1) # check just user omniauth credentials are created
    end

    it "check user is not created twice from facebook credentials" do
      check_conditions(1, 1) # create the user first
      check_conditions(0, 0) # don't create it again
    end
  end

  def check_conditions(change_user_by, change_user_omniauth_credentials_by)
    expect {
      expect {
        post :create, provider: :facebook
      }.to change{ User.count }.by(change_user_by)
    }.to change{ UserOmniauthCredential.count }.by(change_user_omniauth_credentials_by)
  end

end
