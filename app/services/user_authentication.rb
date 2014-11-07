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
    if user.save
      send_welcome_email(user)
      create_new_challenge(user)
    end
    user
  end

  def from_omniauth
    remove_non_ascii_chars
    auth = @request.env["omniauth.auth"]

    if auth["provider"] == "facebook"
      user = from_facebook_omniauth
    elsif auth["provider"] == "twitter"
      user = from_twitter_omniauth
    end
  end

  def from_facebook_omniauth
    auth = @request.env["omniauth.auth"]

    if existing_user = find_user_from_facebook_omniauth
      user = update_from_facebook_omniauth(existing_user)
    else
      user = create_from_facebook_omniauth
    end
  end

  def find_user_from_facebook_omniauth
    auth = @request.env["omniauth.auth"]
    existing_user = nil
    existing_user = User.where(email: auth.info.email).first

    if !existing_user
      user_omniauth_credential = UserOmniauthCredential.where(oauth_uid: auth.uid).first
      existing_user = user_omniauth_credential.user if !user_omniauth_credential.nil?
    end

    existing_user
  end

  def create_from_facebook_omniauth
    auth = @request.env["omniauth.auth"]
    user = User.new
    user.first_name = auth.info.first_name
    user.last_name = auth.info.last_name
    user.username = User.generate_new_username_from_string(auth.info.name)
    user.email = auth.info.email
    user.password = User.generate_random_password(5)
    user.password_confirmation = user.password
    user.oauth_uid = auth.uid
    user.locale = auth.extra.raw_info.locale

    user = autocomplete_new_user_fields(user)

    user.save!

    user.user_omniauth_credentials.create_from_omniauth(auth) # save omniauth credentials

    if !Rails.env.test?
      user.remote_imagename_url = UserFacebookAccount.new(user).remote_image # upload facebook profile image
      user.save
    end

    with_password = false

    with_password = true if User.where(ip: user.ip).count > 1

    send_welcome_email(user, with_password) # send welcome email
    FacebookFriendsWorker.perform_async(user.id) # save facebook friends in the db

    user.just_signup = true

    create_new_challenge(user)

    user
  end

  def update_from_facebook_omniauth(user)
    auth = @request.env["omniauth.auth"]

    if UserFacebookAccount.new(user).fake_account?
      user.just_signup = true
    end

    if UserFacebookAccount.new(user).fake_account?
      FacebookFriendsWorker.perform_async(user.id) # save facebook friends in the db
      create_new_challenge(user)
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
    #user.xp = 100
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
    existing_user = nil
    existing_user = User.where(username: auth.info.nickname).first if existing_user.nil?

    if !existing_user
      user_omniauth_credential = UserOmniauthCredential.where(oauth_uid: auth.uid).first
      existing_user = user_omniauth_credential.user if !user_omniauth_credential.nil?
    end

    existing_user
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

  def send_welcome_email(user, with_password=false)
    if !user.new_record? and !user.skip_emails # avoid callbacks otherwise the tests and fake facebook users will send emails
      MandrillTemplateEmailNotifier.welcome_email_mandrill_template(user).deliver
#      EmailNotifier.welcome_message(user, with_password).deliver
    end
  end

  def autocomplete_new_user_fields(user)
    user.createdtime = Time.now
    user.installed_desktop_app = 0
    user.premium = false
    user.updated_image = 0
    user.created_by = @request.host
    user.ip = @request.remote_ip
    #if @request.location
    #  user.countrycode = @request.location.country_code
    #  user.city = @request.location.city
    #end
    user.challenges_count = 0
    user.xp = 100
    user
  end

  def create_new_challenge(user)
    user.proposed_challenges.create(challenger: User.lars_willner, song: Song.for_new_autogenerated_challenge_lars, instrument: 0, public: false)
    user.proposed_challenges.create(challenger: User.magnus_willner, song: Song.for_new_autogenerated_challenge_magnus, instrument: 0, public: false)
  end

  def remove_non_ascii_chars
    @request.env["omniauth.auth"].info.first_name = I18n.transliterate(@request.env["omniauth.auth"].info.first_name).strip if @request.env["omniauth.auth"].info.first_name
    @request.env["omniauth.auth"].info.last_name = I18n.transliterate(@request.env["omniauth.auth"].info.last_name).strip if @request.env["omniauth.auth"].info.last_name
    @request.env["omniauth.auth"].info.name = I18n.transliterate(@request.env["omniauth.auth"].info.name).strip if @request.env["omniauth.auth"].info.name
    @request.env["omniauth.auth"].info.nickname = I18n.transliterate(@request.env["omniauth.auth"].info.nickname).strip if @request.env["omniauth.auth"].info.nickname
  end
end