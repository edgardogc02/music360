class ResumedFollowedUsersList < UsersList

  include Rails.application.routes.url_helpers

  def initialize(current_user)
    @current_user = current_user
  end

  def title
    "Challenge followed friends"
  end

  def display_more_link
    list_people_path(view: "following")
  end

  def current_user
    @current_user
  end

  def users
    @users ||= UserDecorator.decorate_collection(current_user.followed_users.limit(4))
  end

end