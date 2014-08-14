class ResumedNewGroupsList < GroupsList

  include Rails.application.routes.url_helpers

  def initialize
  end

  def title
    "New Groups"
  end

  def display_more_link
    list_groups_path(view: "new")
  end

  def groups
    @groups ||= GroupDecorator.decorate_collection(Group.last(5).reverse)
  end

end