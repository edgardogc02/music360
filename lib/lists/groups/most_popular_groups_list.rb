class MostPopularGroupsList < PaginatedGroupsList

  include Rails.application.routes.url_helpers

  def display_more?
    false
  end

  def title
    "Popular groups"
  end

  def groups
    @groups ||= GroupDecorator.decorate_collection(Group.by_popularity.page page)
  end

end