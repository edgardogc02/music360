class FacebookFriendsChallengeList < ResumedFacebookFriendsList

  include Rails.application.routes.url_helpers

  def initialize(current_user)
    super(current_user)
  end

  def users
    @users ||= UserChallengeDecorator.decorate_collection(current_user.facebook_friends.limit(4))
  end

end