class UserFacebookFriends

  def initialize(user, facebook_friends)
    @user = user
    @facebook_friends = facebook_friends
  end

  def save
    @facebook_friends.each do |facebook_friend|
      fb_friend = FacebookFriend.new(facebook_friend)
      fb_friend_user = UserFacebookFriends.create_fake_user(fb_friend)
      create_user_facebook_friend_record(fb_friend_user)
      fb_friend_user.user_omniauth_credentials.create_or_update_for_facebook_friend(fb_friend)
    end
  end

  def self.create_fake_user(facebook_friend)
    user = facebook_friend.signin_user

    if !user
      user = User.new
      user.username = User.generate_new_username_from_string(facebook_friend.username)
      user.password = User.generate_random_password(5)
      user.password_confirmation = user.password
      user.email = facebook_friend.new_fake_email
      user.oauth_uid = facebook_friend.id
      user.save
      if !Rails.env.test?
        user.remote_imagename_url = facebook_friend.remote_image
        user.save
      end
      user
    end
    user
  end

  def create_user_facebook_friend_record(fb_friend_user)
    user_fb_friend = @user.user_facebook_friends.where(user_facebook_friend_id: fb_friend_user.id).first

    if !user_fb_friend
      user_fb_friend = @user.user_facebook_friends.build
      user_fb_friend.facebook_friend = fb_friend_user
      user_fb_friend.save
    end
  end

end
