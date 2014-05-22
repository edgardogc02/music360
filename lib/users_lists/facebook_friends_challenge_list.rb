class FacebookFriendsChallengeList < ResumedFacebookFriendsList

  include Rails.application.routes.url_helpers

  def initialize(current_user, song_id)
    super(current_user)
    @song = song_id
  end

  def users
    @users ||= UserChallengeDecorator.decorate_collection(current_user.facebook_friends.limit(4))
  end

  def display_more_link
    list_people_path(view: "facebook", song_id: @song)
  end

end