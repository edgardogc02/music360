class SearchSongsFactory

  def initialize(params)
    if !params[:group_id].blank?
      @songs_list = SearchGroupChallengeSongsList.new(params[:title], params[:page])
    else
      @songs_list = SearchSongsList.new(params[:title], params[:page])
    end
  end

  def songs_list
    @songs_list
  end

end