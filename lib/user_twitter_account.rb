class UserTwitterAccount

  attr_accessor :user, :client

  def initialize(user)
    @user = user

    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = TWITTER_CONSUMER_KEY
      config.consumer_secret     = TWITTER_CONSUMER_SECRET
      config.access_token        = @user.twitter_credentials.oauth_token
      config.access_token_secret = @user.twitter_credentials.oauth_token_secret
    end
  end

  def tweet(text)
    @client.update(text)
  end

end