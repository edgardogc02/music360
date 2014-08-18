class ResumedMyGroupChallengeSongsList < ResumedMySongsList

  def songs
    @songs ||= (SongGroupChallengeDecorator.decorate_collection(Song.created_by_user_id(current_user.id)) + SongGroupChallengeDecorator.decorate_collection(current_user.purchased_songs))[0..4]
  end

end