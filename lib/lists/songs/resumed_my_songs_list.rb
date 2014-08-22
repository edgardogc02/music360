class ResumedMySongsList < SongsList

  include Rails.application.routes.url_helpers

  def initialize(current_user)
    @current_user = current_user
  end

  def title
    "My songs"
  end

  def display_more_link(params={})
    list_songs_path(params.merge(view: "my_songs"))
  end

  def songs
    @songs ||= (created_by_user + purchased + free_songs)[0..4]
  end

  def decorated_songs
    @decorated_songs ||= (created_by_user_decorated + purchased_decorated + free_songs_decorated)[0..4]
  end

  def current_user
    @current_user
  end

  protected

  def free_songs
    @free_songs ||= Song.free
  end

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

  def free_songs_decorated
    @free_songs_decorated ||= SongDecorator.decorate_collection(free_songs)
  end

end