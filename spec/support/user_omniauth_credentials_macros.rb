module UserOmniauthCredentialsMacros
  def create_facebook_omniauth_credentials(user)
    # update the oauth token so it can perform a facebook call.
    user_fb_credentials = user.facebook_credentials

    unless user_fb_credentials
      user_fb_credentials = create(:user_omniauth_credential, provider: "facebook")
    end

    user_fb_credentials.oauth_token = "CAAIAxgRfsqEBAEAoFtRZAivIKSZAFq3RLtQFiJUC9lZBTefnQiHSLLUSKXqqnuaKQTIuQQNgf1fkzQAtpHl8TTVVLHe4Dx0Bl7HZC3xVQC6VeAY02xr5XRm2Hxx7gss33or6hedm1OiHNZCqgcWDpC2BVwKvCGPDbKefRy84T8P1gcWZB4HcWi"
    user_fb_credentials.save
    user_fb_credentials
  end
end