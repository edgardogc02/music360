class ResumedPremiumSongsFactory

  def initialize(params, display_premium)
    if display_premium
      @songs = Song.paid.by_popularity.limit(5)
    else
      @songs = Song.free.not_user_created.by_popularity.limit(5)
    end

    if params[:group_id]
      @songs = SongGroupChallengeDecorator.decorate_collection(@songs)
    else
      @songs = SongDecorator.decorate_collection(@songs)
    end
  end

  def songs
    @songs
  end

end