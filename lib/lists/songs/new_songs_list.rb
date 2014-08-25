class NewSongsList < FilteredSongsList

  include Rails.application.routes.url_helpers

  def display_more?
    false
  end

  def title
    "New"
  end

  def songs
    @songs ||= filtered_songs.not_user_created.by_published_at.page page
  end

end