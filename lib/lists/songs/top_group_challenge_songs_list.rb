class TopGroupChallengeSongsList < TopSongsList

  def songs
    @songs ||= SongGroupChallengeDecorator.decorate_collection(Song.by_popularity.page page)
  end

end