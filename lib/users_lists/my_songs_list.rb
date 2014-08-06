class MySongsList < PaginatedSongsList

  include Rails.application.routes.url_helpers

  def initialize(current_user)
    @current_user = current_user
  end

  def title
    "My songs"
  end

  def songs
    @songs ||= Kaminari.paginate_array(SongDecorator.decorate_collection(Song.created_by_user_id(current_user.id)) + SongDecorator.decorate_collection(current_user.purchased_songs)).page(page)
  end

  def current_user
    @current_user
  end

end