class UserAuthentication

  def initialize(request, params=nil)
    @request = request
    @params = params
  end

  def user
    @user ||= @params ? sign_up : from_omniauth
  end

  def authenticated?
    user.persisted? and !user.deleted?
  end

  private

  def sign_up
    user = autocomplete_new_user_fields(User.new(@params))
    send_welcome_email(user) if user.save
    user
  end

  def from_omniauth
    auth = @request.env["omniauth.auth"]

    if auth["provider"] == "facebook"
      user = from_facebook_omniauth
    elsif auth["provider"] == "twitter"
      user = from_twitter_omniauth
    end
  end

  def from_facebook_omniauth
    auth = @request.env["omniauth.auth"]

    user = find_user_from_facebook_omniauth

    if user.nil?
      user = create_from_facebook_omniauth
    else
      user = update_from_facebook_omniauth(user)
    end
  end

  def find_user_from_facebook_omniauth
    auth = @request.env["omniauth.auth"]
    user = nil
    user = User.where(email: auth.info.email).first
    user = User.where(username: auth.info.name).first if user.nil?
    user_omniauth_credential = UserOmniauthCredential.where(oauth_uid: auth.uid).first
    user = user_omniauth_credential.user if !user_omniauth_credential.nil?

    user
  end

  def create_from_facebook_omniauth
    auth = @request.env["omniauth.auth"]
    user = User.new
    user.first_name = auth.info.first_name
    user.last_name = auth.info.last_name
    user.username = auth.info.name
    user.email = auth.info.email
    user.password = User.generate_random_password(5)
    user.password_confirmation = user.password
    user.oauth_uid = auth.uid
    user.locale = auth.extra.raw_info.locale

    user = autocomplete_new_user_fields(user)

    user.save!

    user.user_omniauth_credentials.create_from_omniauth(auth) # save omniauth credentials

    user.remote_imagename_url = UserFacebookAccount.new(user).remote_image # upload facebook profile image
    user.save

    send_welcome_email(user) # send welcome email
    FacebookFriendsWorker.perform_async(user.id) # save facebook friends in the db

    user.just_signup = true

    user
  end

  def update_from_facebook_omniauth(user)
    auth = @request.env["omniauth.auth"]

    if UserFacebookAccount.new(user).fake_account?
      user.just_signup = true
    end

    user = update_user_from_omniauth(user)
    user.user_omniauth_credentials.create_or_update_from_omniauth(auth)

    user
  end

  def update_user_from_omniauth(user)
    auth = @request.env["omniauth.auth"]
    user.email = auth.info.email
    user.oauth_uid = auth.uid
    user.locale = auth.extra.raw_info.locale
    user.save
    user
  end

  def from_twitter_omniauth
    auth = @request.env["omniauth.auth"]

    user = find_user_from_twitter_omniauth

    if user.nil?
      user = create_from_twitter_omniauth
    else
      user = update_from_twitter_omniauth(user)
    end
  end

  def find_user_from_twitter_omniauth
    user = nil
    user = User.where(username: auth.info.nickname).first if user.nil?
    user_omniauth_credential = UserOmniauthCredential.where(oauth_uid: auth.uid).first
    user = user_omniauth_credential.user if !user_omniauth_credential.nil?

    user
  end

  def create_from_twitter_omniauth
    auth = @request.env["omniauth.auth"]
    user = User.new
    user.first_name = auth.info.name.split(" ").first
    user.last_name = auth.info.name.split(" ").second
    user.username = auth.info.nickname
    user.email = User.generate_random_password(5) + "@lalala.com" # TODO
    user.password = User.generate_random_password(5)
    user.password_confirmation = user.password
    user.oauth_uid = auth.uid
    user.locale = auth.extra.raw_info.locale

    user = autocomplete_new_user_fields(user)
    user.save!

    # send_welcome_email(user) # TODO
    user.user_omniauth_credentials.create_from_omniauth(auth)

    user
  end

  def update_from_twitter_omniauth(user)
    user = update_from_omniauth(user)
    user.user_omniauth_credentials.create_or_update_from_omniauth(auth)

    user
  end

  def send_welcome_email(user)
    if !user.new_record? and !user.skip_emails # avoid callbacks otherwise the tests and fake facebook users will send emails
      EmailNotifier.welcome_message(user).deliver
    end
  end

  def autocomplete_new_user_fields(user)
    user.createdtime = Time.now
    user.installed_desktop_app = 0
    user.premium = true
    user.premium_until = 3.months.from_now
    user.updated_image = 0
    user.created_by = @request.host
    user.ip = @request.remote_ip
    user.countrycode = @request.location.country_code
    user.city = @request.location.city
    user
  end

end