class FacebookFriend

  def initialize(params)
    @id = params['uid']
    @username = params['name']
  end

  def username
    @username
  end

  def id
    @id
  end

  def signin_user
    user = User.find_by_email(self.new_fake_email)

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

end
