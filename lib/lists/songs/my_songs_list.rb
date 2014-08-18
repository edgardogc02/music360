class MySongsList < PaginatedSongsList

  include Rails.application.routes.url_helpers

  def initialize(current_user)
    @current_user = current_user
  end

  def title
    "My songs"
  end

  def songs
    @songs ||= Kaminari.paginate_array(created_by_user + purchased).page(page)
  end

  def decorated_songs
    @decorated_songs ||= Kaminari.paginate_array(created_by_user_decorated + purchased_decorated).page(page)
  end

  def current_user
    @current_user
  end

  protected

  def created_by_user
    @created_by_user ||= Song.created_by_user_id(current_user.id)
  end

  def purchased
    @purchased ||= current_user.purchased_songs
  end

  def created_by_user_decorated
    @created_by_user_decorated ||= SongDecorator.decorate_collection(created_by_user)
  end

  def purchased_decorated
    @purchased_decorated ||= SongDecorator.decorate_collection(purchased)
  end

end