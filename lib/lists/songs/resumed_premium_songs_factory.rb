class ResumedPremiumSongsFactory

  def initialize(params)
    if !params[:group_id].blank?
      @songs_list = ResumedPremiumGroupChallengeSongsList.new
    else
      @songs_list = ResumedPremiumSongsList.new
    end
  end

  def songs_list
    @songs_list
  end

end