class NewSongsList < PaginatedSongsList

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

  def songs
    @songs ||= Song.not_user_created.by_published_at.page page
  end

end