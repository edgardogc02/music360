class NewGroupsList < PaginatedGroupsList

  include Rails.application.routes.url_helpers

  def initialize(page)
    super(page)
  end

  def display_more?
    false
  end

  def title
    "New"
  end

  def groups
    @groups ||= GroupDecorator.decorate_collection(Group.all.page page).reverse
  end

end