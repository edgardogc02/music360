class ResumedMySongsFactory

  def initialize(params, user)
    if params[:group_id]
      @songs = ResumedMyGroupChallengeSongsList.new(user)
    else
      @songs = ResumedMySongsList.new(user)
    end
  end

  def songs
    @songs
  end

end