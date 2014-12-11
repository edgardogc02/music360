class MyGroupChallengeSongsList < MySongsList

  def decorated_songs
    @decorated_songs ||= SongGroupChallengeDecorator.decorate_collection(Song.where(id: created_by_user_decorated + purchased_decorated + free_songs_decorated + songs_for_premium_user_decorated).by_popularity.page(page))
  end

  protected

  def created_by_user_decorated
    @created_by_user_decorated ||= SongGroupChallengeDecorator.decorate_collection(created_by_user)
  end

  def purchased_decorated
    @purchased_decorated ||= SongGroupChallengeDecorator.decorate_collection(purchased)
  end

  def free_songs_decorated
    @free_songs_decorated ||= SongGroupChallengeDecorator.decorate_collection(free_songs)
  end

end