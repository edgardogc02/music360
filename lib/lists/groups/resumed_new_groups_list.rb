class ResumedNewGroupsList < GroupsList

  include Rails.application.routes.url_helpers

  def initialize(current_user)
    @current_user = current_user
  end

  def title
    "New Groups"
  end

  def display_more_link
    list_groups_path(view: "new")
  end

  def current_user
    @current_user
  end

  def groups
    @groups ||= GroupDecorator.decorate_collection(Group.where(id: not_secret_groups + user_secret_groups).by_creation_date.limit(6))
  end

  private

  def not_secret_groups
    @not_secret_gropus ||= Group.not_secret.by_creation_date
  end

  def user_secret_groups
    @user_secret_gropus ||= current_user.groups.secret.by_creation_date
  end

end