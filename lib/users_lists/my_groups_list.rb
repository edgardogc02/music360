class MyGroupsList < PaginatedGroupsList

  include Rails.application.routes.url_helpers

  def initialize(current_user)
    @current_user = current_user
  end

  def title
    "My Groups"
  end
  
  def display_more?
    false
  end

  def groups
    @groups ||= GroupDecorator.decorate_collection(current_user.groups.page page)
  end

  def current_user
    @current_user
  end

end