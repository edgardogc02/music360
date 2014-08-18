class NewGroupChallengeSongsList < NewSongsList

  def songs
    @songs ||= SongGroupChallengeDecorator.decorate_collection(Song.not_user_created.by_popularity.page page)
  end

end