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

end
