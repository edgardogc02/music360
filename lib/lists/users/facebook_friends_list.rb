class FacebookFriendsList < PaginatedUsersList

  include Rails.application.routes.url_helpers

  def initialize(current_user, page)
    @current_user = current_user
    super(page)
  end

  def title
    "Challenge your Facebook friends"
  end

  def display_more?
    false
  end

  def users
    @users ||= UserDecorator.decorate_collection(current_user.facebook_friends.page page)
  end

  def current_user
    @current_user
  end

end