class ResumedMySongsList < SongsList

  include Rails.application.routes.url_helpers

  def initialize(current_user)
    @current_user = current_user
  end

  def title
    "My songs"
  end

  def display_more_link
    list_songs_path(view: "my_songs")
  end

  def songs
    @songs ||= (SongDecorator.decorate_collection(Song.created_by_user_id(current_user.id)) + SongDecorator.decorate_collection(current_user.purchased_songs))[0..4]
  end

  def current_user
    @current_user
  end

end