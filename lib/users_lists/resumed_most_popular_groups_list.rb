class ResumedMostPopularGroupsList < GroupsList

  include Rails.application.routes.url_helpers

  def initialize
  end

  def title
    "Popular groups"
  end

  def display_more_link
    list_groups_path(view: "most_popular")
  end

  def groups
    @groups ||= GroupDecorator.decorate_collection(Group.all.limit(5))
  end

end