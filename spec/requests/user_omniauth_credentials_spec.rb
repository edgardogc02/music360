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
        UserFacebookAccount.new(facebook_user).credentials.should_not be_blank
      end
    end

    context "user already signed in" do
      before(:each) do
        @song = create(:song)
        signin_with_facebook
      end

      it "should update the facebook omniauth credential of the current user" do
        new_mock_facebook_auth_hash
        visit facebook_signin_path

        user = User.first

        User.count.should eq(1)
        UserOmniauthCredential.count.should eq(1)

        user_facebook_account = UserFacebookAccount.new(user)

        user_facebook_account.credentials.oauth_uid.should eq("12345678901")
        user_facebook_account.credentials.user_id.should eq(user.id)
        user_facebook_account.credentials.email.should eq("ladasd@lala.com")
        user_facebook_account.credentials.username.should eq("New Test User")
        user_facebook_account.credentials.oauth_token.should eq("lk2adsadasdasj3lkjasldkjflk3ljsdf")
      end
    end
  end

  context "twitter" do
    context "user not signed in" do
      # SIGN IN/UP WITH TWITTER NOT IMPLEMENTED YET
    end
    context "user signed in" do
      before(:each) do
        @song = create(:song)
        signin_with_facebook
      end

      it "should create a new twitter omniauth credential for the signed in user" do
        mock_twitter_auth_hash

        visit "/auth/twitter"

        user = User.first
        User.count.should eq(1)
        user_twitter_account = UserTwitterAccount.new(user)
        user.user_omniauth_credentials.count.should eq(2)
        user_twitter_account.uid.should eq("123456")
        user_twitter_account.username.should eq("john_doe")
        user_twitter_account.first_name.should eq("John")
        user_twitter_account.last_name.should eq("Doe")
        user_twitter_account.token.should eq("a1b2c3d4weqwe812")
        user_twitter_account.token_secret.should eq("abcdef1234")
      end
    end
  end

end