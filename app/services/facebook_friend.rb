class FacebookFriend

  def initialize(params)
    @id = params['uid']
    @username = params['name']
  end

  def username
    @username
  end

  def already_signin?
    User.find_by_email(self.new_fake_email) or
    User.find_by_username(@username) or
    UserOmniauthCredential.find_by(provider: 'facebook', oauth_uid: @id)
  end

  def new_fake_email
    @id.to_s+"@fakeuser.com"
  end

  def remote_image
    "https://graph.facebook.com/" + @id.to_s + "/picture?type=large"
  end

  def self.create_all(fb_friends)
    fb_friends.each do |fb_friend|
      facebook_friend = FacebookFriend.new(fb_friend)
      if !facebook_friend.already_signin?
        user = User.new
        user.username = facebook_friend.username
        user.password = User.generate_random_password(5)
        user.password_confirmation = user.password
        user.email = facebook_friend.new_fake_email
        user.remote_imagename_url = facebook_friend.remote_image
        user.save!
      end
    end
  end

end
