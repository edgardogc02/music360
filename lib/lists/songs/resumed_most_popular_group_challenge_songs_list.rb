class ResumedMostPopularGroupChallengeSongsList < ResumedMostPopularSongsList

  def songs
    @songs ||= SongGroupChallengeDecorator.decorate_collection(Song.not_user_created.by_published_at.limit(5))
  end

end