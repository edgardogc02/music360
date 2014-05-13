class SearchUsersList < PaginatedUsersList

  include Rails.application.routes.url_helpers

  def initialize(username_or_email, current_user, page="")
    @username_or_email = username_or_email
    @current_user = current_user
    super(page)
  end

  def title
    "Search results"
  end

  def users
    @users ||= UserDecorator.decorate_collection(User.by_username_or_email(username_or_email).exclude(current_user.id).page page)
  end

  def username_or_email
    @username_or_email
  end

  def display_more?
    false
  end

  def current_user
    @current_user
  end

end