class SearchSongsList < PaginatedSongsList

  include Rails.application.routes.url_helpers

  def initialize(search_value, page)
    @search_value = search_value
    super(page)
  end

  def title
    "Songs"
  end

  def display_more?
    false
  end

  def search_value
    @search_value
  end

  def songs
    @songs = Song.not_user_created.by_title(search_value).page(page)
  end

  def paginate?
    true
  end

end