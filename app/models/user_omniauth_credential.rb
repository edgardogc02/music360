class UserOmniauthCredential < ActiveRecord::Base

  belongs_to :user

  def self.create_or_update_from_omniauth(auth)
    user_omniauth_credential = UserOmniauthCredential.where(auth.slice(:provider, :oauth_uid)).first

    if user_omniauth_credential.nil?
      self.create_from_omniauth(auth)
    else
      user_omniauth_credential.update_from_auth(auth)
    end
  end

  def update_from_auth(auth)
    if auth.provider == 'facebook'
      update_from_facebook_auth(auth)
    elsif auth.provider == 'twitter'
      update_from_twitter_auth(auth)
    end
  end

  def update_from_facebook_auth(auth)
    self.username = auth.info.name
    self.first_name = auth.info.first_name
    self.last_name = auth.info.last_name
    self.oauth_token = auth.credentials.token
    self.oauth_expires_at = Time.at(auth.credentials.expires_at)
    self.save!
  end

  def update_from_twitter_auth(auth)
    self.username = auth.info.nickname
    self.first_name = auth.info.name.split(" ").first
    self.last_name = auth.info.name.split(" ").second
    self.oauth_token = auth.credentials.token
    self.oauth_token_secret = auth.credentials.secret
    self.save!
  end

  def self.create_from_omniauth(auth)
    if auth.provider == 'facebook'
      self.create_from_facebook_omniauth(auth)
    elsif auth.provider == 'twitter'
      self.create_from_twitter_omniauth(auth)
    end
  end

  def self.create_from_facebook_omniauth(auth)
    self.create!(provider: auth.provider,
                  oauth_uid: auth.uid,
                  username: auth.info.name,
                  first_name: auth.info.first_name,
                  last_name: auth.info.last_name,
                  email: auth.info.email,
                  oauth_token: auth.credentials.token,
                  oauth_expires_at: Time.at(auth.credentials.expires_at))
  end

  def self.create_from_twitter_omniauth(auth)
    self.create!(provider: auth.provider,
                  oauth_uid: auth.uid,
                  username: auth.info.nickname,
                  first_name: auth.info.name.split(" ").first,
                  last_name: auth.info.name.split(" ").second,
                  # email: auth.info.email,
                  oauth_token: auth.credentials.token,
                  oauth_token_secret: auth.credentials.secret)
  end

end
