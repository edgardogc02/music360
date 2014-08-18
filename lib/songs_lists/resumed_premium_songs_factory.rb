class ResumedPremiumSongsFactory

  def initialize(params, display_premium)
    if display_premium
      @songs_list = Song.paid.by_popularity.limit(5)
    else
      @songs_list = Song.free.not_user_created.by_popularity.limit(5)
    end

    if params[:group_id]
      @songs_list = SongGroupChallengeDecorator.decorate_collection(@songs_list)
    else
      @songs_list = SongDecorator.decorate_collection(@songs_list)
    end
  end

  def songs_list
    @songs_list
  end

end