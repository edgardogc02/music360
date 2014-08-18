class MostPopularGroupChallengeSongsList < MostPopularSongsList

  def songs
    @songs ||= SongGroupChallengeDecorator.decorate_collection(Song.not_user_created.by_published_at.page page)
  end

end