class ResumedPopularUsersList < UsersList

  include Rails.application.routes.url_helpers

  def initialize(exclude_user)
    @exclude_user = exclude_user
  end

  def title
    "Challenge your InstrumentChamp Friends"
  end

  def display_more_link
    list_people_path(view: "users")
  end

  def users
    @users ||= UserDecorator.decorate_collection(User.not_deleted.exclude(exclude_user.id).limit(6))
  end

  def exclude_user
    @exclude_user
  end

end