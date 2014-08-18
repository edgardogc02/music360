class ResumedFacebookFriendsList < UsersList

  include Rails.application.routes.url_helpers

  def initialize(current_user)
    @current_user = current_user
  end

  def title
    "Challenge your Facebook friends"
  end

  def display_more_link
    list_people_path(view: "facebook")
  end

  def users
    @users ||= UserDecorator.decorate_collection(current_user.facebook_friends.limit(6))
  end

  def current_user
    @current_user
  end

end