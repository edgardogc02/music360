class ResumedMostPopularSongsFactory

  def initialize(params)
    if !params[:group_id].blank?
      @songs_list = ResumedMostPopularGroupChallengeSongsList.new
    else
      @songs_list = ResumedMostPopularSongsList.new
    end
  end

  def songs_list
    @songs_list
  end

end