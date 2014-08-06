class ResumedNewSongsList < SongsList

  include Rails.application.routes.url_helpers

  def initialize
  end

  def title
    "New"
  end

  def display_more_link
    list_songs_path(view: "new")
  end

  def songs
    @songs ||= SongDecorator.decorate_collection(Song.not_user_created.by_popularity.limit(5))
  end

end