class TopSongsList < FilteredSongsList

  include Rails.application.routes.url_helpers

  def title
    "Top Songs"
  end

  def display_more?
    false
  end

  def songs
    @songs ||= filtered_songs.by_popularity.page page
  end

  def paginate?
    true
  end

end