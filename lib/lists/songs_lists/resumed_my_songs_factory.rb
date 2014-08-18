class ResumedMySongsFactory

  def initialize(params, user)
    if params[:group_id]
      @songs_list = ResumedMyGroupChallengeSongsList.new(user)
    else
      @songs_list = ResumedMySongsList.new(user)
    end
  end

  def songs_list
    @songs_list
  end

end