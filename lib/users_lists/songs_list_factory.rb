class SongsListFactory

  def initialize(type, current_user, page)
    if type == "top"
      @songs_list = TopSongsList.new(page)
    elsif type == "my_songs"
      @songs_list = MySongsList.new(current_user)
    elsif type == "most_popular"
      @songs_list = MostPopularSongsList.new(page)
    elsif type == "new"
      @songs_list = NewSongsList.new(page)
    end
  end

  def songs_list
    @songs_list
  end

end