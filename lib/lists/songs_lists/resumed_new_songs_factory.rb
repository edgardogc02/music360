class ResumedNewSongsFactory

  def initialize(params)
    if params[:group_id]
      @songs_list = ResumedNewGroupChallengeSongsList.new
    else
      @songs_list = ResumedNewSongsList.new
    end
  end

  def songs_list
    @songs_list
  end

end