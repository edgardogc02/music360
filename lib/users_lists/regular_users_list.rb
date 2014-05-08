class RegularUsersList < PaginatedUsersList

  include Rails.application.routes.url_helpers

  def initialize(exclude_user, page)
    @exclude_user = exclude_user
    super(page)
  end

  def title
    "Challenge people on InstrumentChamp"
  end

  def display_more?
    false
  end

  def users
    @users ||= UserDecorator.decorate_collection(User.not_deleted.exclude(exclude_user.id).limit(50).page page)
  end

  def exclude_user
    @exclude_user
  end

end