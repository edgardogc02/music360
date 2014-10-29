class TopUsersList < PaginatedUsersList

  include Rails.application.routes.url_helpers

  def initialize(exclude_user, page)
    @exclude_user = exclude_user
    super(page)
  end

  def title
    "Top Users"
  end

  def display_more?
    false
  end

  def users
    @users ||= UserDecorator.decorate_collection(User.not_deleted.exclude(exclude_user.id).by_xp.page page)
  end

  def exclude_user
    @exclude_user
  end

  def paginate?
    true
  end

end