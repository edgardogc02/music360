require 'spec_helper'

describe User do

  context "Validations" do
    it { should have_secure_password }

    it "should validate username" do
      pending "check if we'll use useranme or not"
      should validate_presence_of(:username)
      validate_uniqueness_of(:username)
    end

    it "should validate email" do
      should validate_presence_of(:email)
      validate_uniqueness_of(:email)
      should allow_value('test@test.com', 'test@test.com.ar').for(:email)
      should_not allow_value('@test.com', 'test@.com', 'test@sdads@asasd.com', 'test@ad.com.com.com').for(:email)
    end

    it "should validate password" do
      should validate_presence_of(:password)
      should validate_presence_of(:password_confirmation)
    end
  end

  context "Associations" do
    it "should have many challenges" do
      pending "check how are challenges done"
      should have_many(:challenges)
    end

    it { should belong_to(:people_category) }

    [:user_omniauth_credentials, :user_sent_facebook_invitations].each do |assoc|
      it "should have has many #{assoc} with dependent destroy" do
        should have_many(assoc).dependent(:destroy)
      end
    end
  end

  context "Methods" do
    it "should create new user from omniauth facebook credentials" do
      expect { User.from_omniauth(mock_facebook_auth_hash) }.to change{User.count}.by(1)
    end

    it "should not create new user from omniauth facebook credentials" do
      create(:user, email: "test@test.com") # email from facebook
      expect { User.from_omniauth(mock_facebook_auth_hash) }.to change{User.count}.by(0)
    end
  end

end