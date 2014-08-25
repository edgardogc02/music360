class SongsListFactory

  def initialize(current_user, params)
    if params[:view] == "top"
      if params[:group_id]
        @songs_list = TopGroupChallengeSongsList.new(params[:page])
      else
        @songs_list = TopSongsList.new(params[:page])
      end
    elsif params[:view] == "my_songs"
      if params[:group_id]
        @songs_list = MyGroupChallengeSongsList.new(current_user)
      else
        @songs_list = MySongsList.new(current_user, params)
      end
    elsif params[:view] == "most_popular"
      if params[:group_id]
        @songs_list = MostPopularGroupChallengeSongsList.new(params[:page])
      else
        @songs_list = MostPopularSongsList.new(params)
      end
    elsif params[:view] == "new"
      if params[:group_id]
        @songs_list = NewGroupChallengeSongsList.new(params[:page])
      else
        @songs_list = NewSongsList.new(params)
      end
    elsif params[:view] == "featured"
      if params[:group_id]
        @songs_list = PremiumGroupChallengeSongsList.new(params[:page])
      else
        @songs_list = PremiumSongsList.new(params[:page])
      end
    end
  end

  def songs_list
    @songs_list
  end

end