class MySongsList < FilteredSongsList

  include Rails.application.routes.url_helpers

  def initialize(current_user, params)
    @current_user = current_user
    super(params)
  end

  def title
    "My songs"
  end

  def songs
    @songs ||= Kaminari.paginate_array(created_by_user + purchased + free_songs).page(page)
  end

  def decorated_songs
    @decorated_songs ||= Kaminari.paginate_array(created_by_user_decorated + purchased_decorated + free_songs_decorated + songs_for_premium_user_decorated).page(page)
  end

  def current_user
    @current_user
  end

  def display_more?
    false
  end

  protected

  def free_songs
    @free_songs ||= filtered_songs.free
  end

  def created_by_user
    @created_by_user ||= filtered_songs.created_by_user_id(current_user.id)
  end

  def purchased
    @purchased ||= filtered_songs.where(id: current_user.purchased_songs)
  end

  def songs_for_premium_user
    if current_user.premium?
      @for_premium_user ||= Song.accessible_for_premium_subscription
    else
      @for_premium_user ||= []
    end
  end

  def created_by_user_decorated
    @created_by_user_decorated ||= SongDecorator.decorate_collection(created_by_user)
  end

  def purchased_decorated
    @purchased_decorated ||= SongDecorator.decorate_collection(purchased)
  end

  def free_songs_decorated
    @free_songs_decorated ||= SongDecorator.decorate_collection(free_songs)
  end

  def songs_for_premium_user_decorated
    @songs_for_premium_user_decorated ||= SongDecorator.decorate_collection(songs_for_premium_user)
  end

end