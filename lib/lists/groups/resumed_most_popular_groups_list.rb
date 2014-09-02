class ResumedMostPopularGroupsList < GroupsList

  include Rails.application.routes.url_helpers

  def initialize(current_user)
    @current_user = current_user
  end

  def title
    "Popular groups"
  end

  def display_more_link
    list_groups_path(view: "most_popular")
  end

  def current_user
    @current_user
  end

  def groups
    @groups ||= GroupDecorator.decorate_collection(Group.where(id: not_secret_groups + user_secret_groups).by_popularity.limit(6))
  end

  private

  def not_secret_groups
    @not_secret_gropus ||= Group.not_secret.by_popularity
  end

  def user_secret_groups
    @user_secret_gropus ||= current_user.groups.secret.by_popularity
  end

end