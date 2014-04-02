require 'spec_helper'

describe UserOmniauthCredential do

  context "Associations" do
    it "should belongs to user" do
      should belong_to(:user)
    end
  end

  context "Methods" do
    it "should create new user omniauth credential from facebook" do
      expect { UserOmniauthCredential.create_or_update_from_omniauth(mock_facebook_auth_hash) }.to change{UserOmniauthCredential.count}.by(1)
    end

    it "should not create the facebook credentials twice" do
      expect { UserOmniauthCredential.create_or_update_from_omniauth(mock_facebook_auth_hash) }.to change{UserOmniauthCredential.count}.by(1)
      expect { UserOmniauthCredential.create_or_update_from_omniauth(mock_facebook_auth_hash) }.to change{UserOmniauthCredential.count}.by(0)
    end
  end

end