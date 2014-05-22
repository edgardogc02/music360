class UserTwitterAccount

  attr_accessor :user

  def initialize(user)
    @user = user
  end

  def credentials
    @credentials ||= @user.user_omniauth_credentials.find_by(provider: 'twitter')
  end

  def connected?
    !credentials.blank?
  end

  # TODO: Extract this method to a parent class and share them with user_facebook_account class
  def username
    credentials.username
  end

  def uid
    credentials.oauth_uid
  end

  def first_name
    credentials.first_name
  end

  def last_name
    credentials.last_name
  end

  def token
    credentials.oauth_token
  end

  def token_secret
    credentials.oauth_token_secret
  end

  def connect
    @twitter ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = TWITTER_CONSUMER_KEY
      config.consumer_secret     = TWITTER_CONSUMER_SECRET
      config.access_token        = token
      config.access_token_secret = token_secret
    end
  end

  def tweet(text)
    connect.update(text)
  end

end