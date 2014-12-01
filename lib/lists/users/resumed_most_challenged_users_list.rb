class ResumedMostChallengedUsersList < UsersList

  include Rails.application.routes.url_helpers

  def initialize(current_user)
    @current_user = current_user
  end

  def title
    "Challenge your InstrumentChamp Friends"
  end

  def display_more_link
    list_people_path(view: "users")
  end

  def users
    @users ||= UserDecorator.decorate_collection(current_user.most_challenged_users(20))
  end

  def current_user
    @current_user
  end

end