class ResumedMostPopularSongsFactory

  def initialize(params)
    if params[:group_id]
      @songs = ResumedMostPopularGroupChallengeSongsList.new
    else
      @songs = ResumedMostPopularSongsList.new
    end
  end

  def songs
    @songs
  end

end