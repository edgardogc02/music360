class SearchSongsFactory

  def initialize(params, display_premium)
    if !params[:group_id].blank?
      @songs_list = SearchGroupChallengeSongsList.new(display_premium, params[:title], params[:page])
    else
      @songs_list = SearchSongsList.new(display_premium, params[:title], params[:page])
    end
  end

  def songs_list
    @songs_list
  end

end