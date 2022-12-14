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

    [[:proposed_challenges, 'Challenge', 'challenged_id'], [:inverse_user_followers, 'UserFollower', 'follower_id'],
      [:initiated_groups, 'Group', 'initiator_user_id']].each do |assoc, class_name, foreign_key|
      it "should have many #{assoc} with class name #{class_name} and foreign key #{foreign_key}" do
        should have_many(assoc).class_name(class_name).with_foreign_key(foreign_key)
      end
    end

    [:user_omniauth_credentials, :user_facebook_friends, :user_facebook_invitations, :user_invitations, :user_purchased_songs,
      :group_invitations, :user_mp_updates, :user_followers].each do |assoc|
      it "should have has many #{assoc} with dependent destroy" do
        should have_many(assoc).dependent(:destroy)
      end
    end

    [[:followers_groups, :followers, :groups], [:facebook_friends_groups, :facebook_friends, :groups],
      [:followed_users, :inverse_user_followers, :followed], [:followers, :user_followers, :follower],
      [:facebook_friends, :user_facebook_friends, :facebook_friend]].each do |assoc, through, source|
      it "should have many #{assoc} through #{through} with source #{source}" do
        should have_many(assoc).through(through).source(source)
      end
    end

    [[:purchased_songs, :user_purchased_songs], [:groups, :user_groups]].each do |assoc, through|
      it "should have many #{assoc} through #{through}" do
        should have_many(assoc).through(through)
      end
    end

    it "should have many groups invited to" do
      pending
#      should have_many(:groups_invited_to).through(:group_invitations).source(:group)
    end

    it "should have many published group posts" do
      should have_many(:published_group_posts).class_name('GroupPost').with_foreign_key("publisher_id").dependent(:destroy)
    end

    [:payments, :user_premium_subscriptions, :user_groups, :activity_likes, :activity_comments, :user_level_upgrades, :user_posts].each do |assoc|
      it "should have many #{assoc}" do
        should have_many(assoc)
      end
    end

    it "should have many liked_activities through activity_likes with source activity" do
      should have_many(:liked_activities).through(:activity_likes).source(:activity)
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

    it "should order by xp desc" do
      user = create(:user, xp: 0)
      user1 = create(:user, xp: 10)
      user2 = create(:user, xp: 5)
      user3 = create(:user, xp: 12)

      User.by_xp.should eq([user3, user1, user2, user])
    end
  end

  context "Methods" do

    it "should return if a user likes an activity" do
      pending
    end

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
      pending 'email is failing'
      followed = create(:user)
      follower = create(:user)

      expect { follower.follow(followed) }.to change{UserFollower.count}.by(1)

      follower.should be_following(followed)
      followed.should_not be_following(follower)
    end

    it "should verify that user cant follow another user more than once" do
      pending 'email is failing'
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

    it 'Should assign xp points to user' do
      user = create(:user, xp: 90)

      user.assign_xp_points(100)
      user.xp.should eq(190)
    end

  end

  def build_request
    OpenStruct.new({host: "localhost", env: {"omniauth.auth" => mock_facebook_auth_hash}, location: OpenStruct.new({city: "Cordoba", country_code: "AR"})})
  end

end