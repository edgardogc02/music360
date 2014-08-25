class MostPopularSongsList < FilteredSongsList

  include Rails.application.routes.url_helpers

  def initialize(params)
    super(params)
  end

  def display_more?
    false
  end

  def title
    "Most popular"
  end

  def songs
    @songs ||= filtered_songs.not_user_created.by_popularity.page page
  end

end