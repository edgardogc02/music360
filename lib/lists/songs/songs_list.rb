class SongsList < List

  def songs
    objects
  end

  def decorated_songs
    @decorated_songs ||= SongDecorator.decorate_collection(songs)
  end

end