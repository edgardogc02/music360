class ResumedMyGroupsList < GroupsList

  include Rails.application.routes.url_helpers

  def initialize(current_user)
    @current_user = current_user
  end

  def title
    "My Groups"
  end

  def display_more_link
    list_groups_path(view: "my_groups")
  end

  def groups
    @groups ||= GroupDecorator.decorate_collection(current_user.groups.limit(6))
  end

  def current_user
    @current_user
  end

end