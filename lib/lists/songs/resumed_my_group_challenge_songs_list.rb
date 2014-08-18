class ResumedMyGroupChallengeSongsList < ResumedMySongsList

  protected

  def created_by_user_decorated
    @created_by_user_decorated ||= SongGroupChallengeDecorator.decorate_collection(created_by_user)
  end

  def purchased_decorated
    @purchased_decorated ||= SongGroupChallengeDecorator.decorate_collection(purchased)
  end

end