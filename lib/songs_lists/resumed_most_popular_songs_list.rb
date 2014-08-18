class ResumedMostPopularSongsList < SongsList

  include Rails.application.routes.url_helpers

  def initialize
  end

  def title
    "Most popular"
  end

  def display_more_link(params={})
    list_songs_path(params.merge(view: "most_popular"))
  end

  def songs
    @songs ||= SongDecorator.decorate_collection(Song.not_user_created.by_published_at.limit(5))
  end

end