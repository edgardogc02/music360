module SongGroupChallengeDecorated

  def decorated_songs
    @decorated_songs ||= SongGroupChallengeDecorator.decorate_collection(songs)
  end

end