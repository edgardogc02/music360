class MyGroupChallengeSongsList < MySongsList

  def songs
    @songs ||= Kaminari.paginate_array(SongGroupChallengeDecorator.decorate_collection(Song.created_by_user_id(current_user.id)) + SongGroupChallengeDecorator.decorate_collection(current_user.purchased_songs)).page(page)
  end

end