require 'spec_helper'

describe User do

  context "Validations" do
    it { should have_secure_password }

    it "should validate username" do
      should validate_presence_of(:username)
      validate_uniqueness_of(:username)
      should allow_value('test', 'test User2-2_1', 'test@test.com', 'test@test.com.ar').for(:username)
      should_not allow_value('test#user', 'test úser').for(:username)
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
      should have_many(:challenges).with_foreign_key('challenger_id')
    end

    it "should have many proposed challenges" do
      should have_many(:proposed_challenges).class_name('Challenge').with_foreign_key('challenged_id')
    end

    it "should have many followers associations" do
      should have_many(:user_followers).dependent(:destroy)
      should have_many(:inverse_user_followers).class_name('UserFollower').with_foreign_key("follower_id")
      should have_many(:followers).through(:user_followers).source(:follower)
      should have_many(:followed_users).through(:inverse_user_followers).source(:followed)
    end

    [:user_omniauth_credentials, :user_facebook_friends, :user_facebook_invitations, :user_invitations, :user_purchased_songs, :group_invitations].each do |assoc|
      it "should have has many #{assoc} with dependent destroy" do
        should have_many(assoc).dependent(:destroy)
      end
    end

    [[:purchased_songs, :user_purchased_songs], [:groups, :user_groups]].each do |assoc, through|
      it "should have many #{assoc} through #{through}" do
        should have_many(assoc).through(through)
      end
    end

    it "should have many groups invited to" do
      should have_many(:groups_invited_to).through(:group_invitations).source(:group)
    end

    it "shuold have many initiated_groups" do
      should have_many(:initiated_groups).class_name('Group').with_foreign_key("initiator_user_id")
    end

    [:payments, :user_premium_subscriptions, :user_groups].each do |assoc|
      it "should have many #{assoc}" do
        should have_many(assoc)
      end
    end

    it "should have many facebook friends" do
      should have_many(:facebook_friends).through(:user_facebook_friends).source(:facebook_friend)
    end

    [:user_category, :instrument].each do |assoc|
      it "should belongs to #{assoc}" do
        should belong_to(assoc)
      end
    end
  end

  context "Scopes" do
    it "should list not deleted users" do
      user = create(:user)
      user_2 = create(:user)
      user_3 = create(:user)
      user_4 = create(:user)
      user_3.destroy

      User.not_deleted.should eq([user, user_2, user_4])
    end

    it "should search users by username or email" do
      user = create(:user, username: "testuser")
      user_2 = create(:user, username: "testuser2")
      user_3 = create(:user, username: "lalala", email: "asda@sdas.com")
      user_4 = create(:user, username: "lalal", email: "testuser@adas.com")
      user_5 = create(:user, username: "lal", email: "ad@adas.com")

      User.by_username_or_email("test").should eq([user, user_2, user_4])
    end

    it "should return all users that are not connected via facebook" do
      user = create(:user)
      user1 = create(:user)
      user2 = create(:user, oauth_uid: "123456")

      User.not_connected_via_facebook.should eq([user, user1])
    end

    it "should exclude user from users list" do
      user = create(:user)
      user1 = create(:user)

      User.exclude(user.id).should eq([user1])
    end

    it "should order the users by challenges_count" do
      user = create(:user, challenges_count: 9)
      user1 = create(:user, challenges_count: 0)
      user2 = create(:user, challenges_count: 10)

      User.order_by_challenges_count.should eq([user2, user, user1])
    end

    it "should exclude users" do
      user = create(:user, username: "lalo")
      user1 = create(:user, username: "user1")
      user2 = create(:user, username: "user2")

      User.excludes(User.last(2)).should eq([user])
    end
  end

  context "Methods" do
    it "should create new user from omniauth facebook credentials" do
      expect { UserAuthentication.new(build_request).authenticated? }.to change{User.count}.by(1)
    end

    it "should not create new user from omniauth facebook credentials" do
      create(:user, email: "facebook_kehfokn_user@tfbnw.net") # email from facebook
      expect { UserAuthentication.new(build_request).authenticated? }.to change{User.count}.by(0)
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

    it "should mark a user as deleted" do
      user = create(:user)
      user.destroy
      user.should be_deleted
    end

    it "should register all fb friends in our database" do
      user = create(:user)
      check_facebook_friends_changes(user, 5, 5)
    end

    it "should create users with other username if username is already taken" do
      user = create(:user)
      fb_user = create(:user, username: "Bob Sadanwitz")
      check_facebook_friends_changes(user, 5, 5)
    end

    it "should not register fb friends if already created with email" do
      user = create(:user)
      fb_user = create(:user, email: FacebookFriend.new({"uid"=>1375536292736028, "name"=>"Dick Smithberg"}).new_fake_email)
      check_facebook_friends_changes(user, 4, 5)
    end

    it "should not register fb friends if user already signed in using facebook" do
      user = create(:user)
      fb_user = create(:user)
      create(:user_omniauth_credential, user: fb_user, oauth_uid: "1375536292736028")
      check_facebook_friends_changes(user, 4, 5)
    end

    it "should not create fb friends twice" do
      user = create(:user)
      check_facebook_friends_changes(user, 5, 5)
      check_facebook_friends_changes(user, 0, 0)
    end

    def check_facebook_friends_changes(user, user_count_change, user_facebook_friends_count_change)
      expect { expect { UserFacebookFriends.new(user, facebook_friends).save }.to change{User.count}.by(user_count_change) }.to change{UserFacebookFriend.count}.by(user_facebook_friends_count_change)
    end

    it "should return groupies to connect with" do
      user = create(:user)
      UserFacebookFriends.new(user, facebook_friends).save

      user_facebook_friend_ids = user.user_facebook_friends.pluck(:user_facebook_friend_id)
      UserFacebookAccount.new(user).groupies_to_connect_with.should eq(User.find(user_facebook_friend_ids))
    end

    it "should return groupies to connect with even if they already exist in the db" do
      user = create(:user)
      new_user = create(:user, username: "Ashutosh Morwal")
      UserFacebookFriends.new(user, facebook_friends).save

      user_facebook_friend_ids = user.user_facebook_friends.pluck(:user_facebook_friend_id)
      UserFacebookAccount.new(user).groupies_to_connect_with.should eq(User.find(user_facebook_friend_ids))
    end

    it "should return the correct user level" do
      level1 = create(:level, xp: 0)
      level2 = create(:level, xp: 107)
      level3 = create(:level, xp: 314)
      level4 = create(:level, xp: 621)
      level5 = create(:level, xp: 1028)
      level6 = create(:level, xp: 1535)
      level7 = create(:level, xp: 2142)

      user = create(:user)
      user.level.should eq(level1.title)

      user.xp = 0
      user.save
      user.level.should eq(level1.title)

      user.xp = 20
      user.save
      user.level.should eq(level1.title)

      user.xp = 107
      user.save
      user.level.should eq(level2.title)

      user.xp = 778
      user.save
      user.level.should eq(level4.title)

      user.xp = 18782
      user.save
      user.level.should eq(level7.title)
    end

    context "paid songs" do
      it "should not be able to buy free songs" do
        user = create(:user)
        song = create(:song)
        user.can_buy_song?(song).should_not be_true
      end

      it "should be able to buy a song twice" do
        user = create(:user)
        paid_song = create(:paid_song)
        user_purchased_song = create(:user_purchased_song, user: user, song: paid_song)
        user.can_buy_song?(paid_song).should_not be_true
      end

      it "should be able to but a paid song" do
        user = create(:user)
        paid_song = create(:paid_song)
        user.can_buy_song?(paid_song).should be_true
      end
    end
  end

  def build_request
    OpenStruct.new({host: "localhost", env: {"omniauth.auth" => mock_facebook_auth_hash}, location: OpenStruct.new({city: "Cordoba", country_code: "AR"})})
  end

end