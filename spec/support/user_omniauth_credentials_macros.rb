module UserOmniauthCredentialsMacros
  def create_facebook_omniauth_credentials(user)
    # update the oauth token so it can perform a facebook call.
    user_fb_credentials = UserFacebookAccount.new(user).credentials

    unless user_fb_credentials
      user_fb_credentials = create(:user_omniauth_credential, provider: "facebook")
    end

    user_fb_credentials.oauth_token = "CAAKYpVzGhT0BAPuWoWZCZBbQ3u7gZBOTDl6K4yi4Y9gsnVMq6dgGhkGQPmVKIBj0NIo8aEibvXwwm5Ip0iID68OoRayj9WbxFaoTZCcX76zZC7Gtq1EAAIWmZAhYfFTD0ZCS99o60jru4NSR0Y8v7guxJkTioTAbrZBTQqEjdbIzy5hCzIMb3EeP"
    user_fb_credentials.save
    user_fb_credentials
  end
end