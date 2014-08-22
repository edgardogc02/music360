class ResumedPremiumSongsList < SongsList

  include Rails.application.routes.url_helpers

  def initialize
  end

  def title
    "Featured songs"
  end

  def display_more_link(params={})
    list_songs_path(params.merge(view: "featured"))
  end

  def songs
    @songs ||= Song.paid.by_popularity.limit(5)
  end

end