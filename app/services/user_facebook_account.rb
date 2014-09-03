class UserFacebookAccount

  attr_accessor :user

  def initialize(user)
    @user = user
  end

  def credentials
    @credentials ||= @user.user_omniauth_credentials.find_by(provider: 'facebook')
  end

  def connected?
    !credentials.blank?
  end

  def connect
    @facebook ||= Koala::Facebook::API.new(credentials.oauth_token)
  end

  def remote_image
    "https://graph.facebook.com/" + credentials.oauth_uid.to_s + "/picture?type=large"
  end

  def uid
    if connected?
      credentials.oauth_uid
    elsif fake_account?
      @user.email[0, @user.email.index("@")]
    else
      ""
    end
  end

  def fake_account?
    @user.email.include? "@fakeuser.com"
  end

  def groupies_to_connect_with
    @user.facebook_friends
  end

  def top_friends(limit=0)
    sql = "SELECT uid, name FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 = me()) ORDER BY mutual_friend_count DESC"
    if limit > 0
      sql = sql + " LIMIT #{limit}"
    end
    connect.fql_query(sql)
  end

end