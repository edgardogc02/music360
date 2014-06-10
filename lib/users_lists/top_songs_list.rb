class TopSongsList < PaginatedSongsList

  include Rails.application.routes.url_helpers

  def initialize(page)
    super(page)
  end

  def title
    "Top Songs"
  end

  def display_more?
    false
  end

  def songs
    @songs ||= SongDecorator.decorate_collection(Song.by_popularity.limit(20).page page)
  end

end