class TopSongsList < PaginatedSongsList

  include Rails.application.routes.url_helpers

  def initialize(page)
    super(page)
  end

  def title
    "Top Songs"
  end

  def display_more?
    true
  end
  
  def display_more_link
    songs_path
  end

  def songs
    @songs ||= SongDecorator.decorate_collection(Song.by_popularity.limit(12))
  end
  
  def paginate?
    false
  end

end