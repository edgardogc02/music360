class FacebookFriend

  def initialize(params)
    @id = params['uid']
    @username = params['name']
  end

  def username
    @username
  end

  def signin_user
    user = User.find_by_email(self.new_fake_email)
    user = User.find_by_username(@username) unless user
    unless user
      c = UserOmniauthCredential.find_by(provider: 'facebook', oauth_uid: @id)
      user = c.user if c
    end
    user
  end

  def already_signin?
    !signin_user.blank?
  end

  def new_fake_email
    @id.to_s+"@fakeuser.com"
  end

  def remote_image
    "https://graph.facebook.com/" + @id.to_s + "/picture?type=large"
  end

  def self.save_all_friends_for_user(user, fb_friends)
    fb_friends.each do |fb_friend|
      fb_friend_user = FacebookFriend.create_new_fake_user(FacebookFriend.new(fb_friend))
      FacebookFriend.create_new_user_facebook_friend(user, fb_friend_user)
    end
  end

  def self.create_new_fake_user(facebook_friend)
    user = facebook_friend.signin_user

    if !user
      user = User.new
      user.username = facebook_friend.username
      user.password = User.generate_random_password(5)
      user.password_confirmation = user.password
      user.email = facebook_friend.new_fake_email
      user.save!
      user.remote_imagename_url = facebook_friend.remote_image
      user.save!
      user
    end
    user
  end

  def self.create_new_user_facebook_friend(user, fb_friend_user)
    user_fb_friend = user.user_facebook_friends.where(user_facebook_friend_id: fb_friend_user.id).first

    if !user_fb_friend
      user_fb_friend = user.user_facebook_friends.build
      user_fb_friend.facebook_friend = fb_friend_user
      user_fb_friend.save!
    end
  end

end
