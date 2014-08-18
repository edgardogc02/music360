class ResumedNewGroupChallengeSongsList < ResumedNewSongsList

  def songs
    @songs ||= SongGroupChallengeDecorator.decorate_collection(Song.not_user_created.by_popularity.limit(5))
  end

end