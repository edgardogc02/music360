class ResumedNewSongsFactory

  def initialize(params)
    if params[:group_id]
      @songs = ResumedNewGroupChallengeSongsList.new
    else
      @songs = ResumedNewSongsList.new
    end
  end

  def songs
    @songs
  end

end