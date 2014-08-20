class ResumedNewSongsList < SongsList

  include Rails.application.routes.url_helpers

  def initialize
  end

  def title
    "New"
  end

  def display_more_link(params={})
    list_songs_path(params.merge(view: "new"))
  end

  def songs
    @songs ||= Song.not_user_created.by_published_at.limit(5)
  end

end