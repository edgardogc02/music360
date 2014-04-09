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
      should have_many(:challenges).with_foreign_key('user1')
    end

    it "should have many proposed challenges" do
      should have_many(:proposed_challenges).class_name('Challenge').with_foreign_key('user2')
    end

    it "should have many followers associations" do
      should have_many(:user_followers).dependent(:destroy)
      should have_many(:inverse_user_followers).class_name('UserFollower').with_foreign_key("follower_id")
      should have_many(:followers).through(:user_followers).source(:follower)
      should have_many(:followed_users).through(:inverse_user_followers).source(:followed)
    end

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

    it "should verify following method" do
      user_follower = create(:user_follower)
      followed = user_follower.followed
      follower = user_follower.follower

      follower.should be_following(followed)
      followed.should_not be_following(follower)
    end

    it "should verify follow method" do
      followed = create(:user)
      follower = create(:user)

      expect { follower.follow(followed) }.to change{UserFollower.count}.by(1)

      follower.should be_following(followed)
      followed.should_not be_following(follower)
    end

    it "should verify that user cant follow another user more than once" do
      followed = create(:user)
      follower = create(:user)

      expect { follower.follow(followed) }.to change{UserFollower.count}.by(1)
      expect { follower.follow(followed) }.to change{UserFollower.count}.by(0)
    end

    it "should not be able to follow him self" do
      user = create(:user)

      expect { user.follow(user) }.to change{UserFollower.count}.by(0)

      user.should_not be_following(user)
    end
  end

end