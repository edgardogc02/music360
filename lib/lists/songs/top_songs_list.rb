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
    @songs ||= SongDecorator.decorate_collection(Song.by_popularity.page page)
  end
  
  def paginate?
    true
  end

end