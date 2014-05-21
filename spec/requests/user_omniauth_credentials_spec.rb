require 'spec_helper'

describe "UserOmniauthCredentials" do

  before(:each) do
    @song = create(:song)
  end

  context "facebook" do
    context "user not signed in" do
      it "should create a new user and omniauth credential record" do
        user = create(:user, username: "First user")
        signin_with_facebook

        facebook_user = User.find_by(username: "Test User")
        User.count.should eq(2)
        facebook_user.should_not be_blank
        facebook_user.facebook_credentials.should_not be_blank
      end
    end

    context "user already signed in" do
      before(:each) do
        @user = create(:song)
        signin_with_facebook
      end

      it "should update the facebook omniauth credential of the current user" do
        new_mock_facebook_auth_hash
        visit facebook_signin_path

        user = User.first

        User.count.should eq(1)
        UserOmniauthCredential.count.should eq(1)

        user.facebook_credentials.oauth_uid.should eq("12345678901")
        user.facebook_credentials.user_id.should eq(user.id)
        user.facebook_credentials.email.should eq("ladasd@lala.com")
        user.facebook_credentials.username.should eq("New Test User")
        user.facebook_credentials.oauth_token.should eq("lk2adsadasdasj3lkjasldkjflk3ljsdf")
      end
    end
  end

  context "twitter" do
    context "user not signed in" do
      # SIGN IN/UP WITH TWITTER NOT IMPLEMENTED YET
    end
    context "user signed in" do
      before(:each) do
        @user = create(:song)
        signin_with_facebook
      end

      it "should create a new twitter omniauth credential for the signed in user" do
        mock_twitter_auth_hash

        visit "/auth/twitter"

        user = User.first
        User.count.should eq(1)
        user.user_omniauth_credentials.count.should eq(2)
        user.twitter_credentials.oauth_uid.should eq("123456")
        user.twitter_credentials.username.should eq("john_doe")
        user.twitter_credentials.first_name.should eq("John")
        user.twitter_credentials.last_name.should eq("Doe")
        user.twitter_credentials.oauth_token.should eq("a1b2c3d4weqwe812")
        user.twitter_credentials.oauth_token_secret.should eq("abcdef1234")
      end
    end
  end

end