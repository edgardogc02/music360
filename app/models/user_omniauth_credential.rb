class UserOmniauthCredential < ActiveRecord::Base

  belongs_to :user

  def self.create_or_update_from_omniauth(auth)
    user_omniauth_credential = UserOmniauthCredential.where(auth.slice(:provider, :oauth_uid)).first

    if user_omniauth_credential.nil?
      self.create_from_omniauth(auth)
    else
      user_omniauth_credential.username = auth.info.name
      user_omniauth_credential.first_name = auth.info.first_name
      user_omniauth_credential.last_name = auth.info.last_name
      user_omniauth_credential.oauth_token = auth.credentials.token
      user_omniauth_credential.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user_omniauth_credential.save!
    end
  end

  def self.create_from_omniauth(auth)
    self.create!(provider: auth.provider, oauth_uid: auth.uid, username: auth.info.name, first_name: auth.info.first_name, last_name: auth.info.last_name, email: auth.info.email, oauth_token: auth.credentials.token, oauth_expires_at: Time.at(auth.credentials.expires_at))
  end

end
