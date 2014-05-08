class FollowedUsersList < PaginatedUsersList

  include Rails.application.routes.url_helpers

  def initialize(current_user, page)
    @current_user = current_user
    super(page)
  end

  def title
    "Challenge followed friends"
  end

  def display_more?
    false
  end

  def users
    @users ||= UserDecorator.decorate_collection(current_user.followed_users.page page)
  end

  def current_user
    @current_user
  end

end