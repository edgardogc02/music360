class SongsListFactory

  def initialize(type, page)
    if type == "top"
      @songs_list = TopSongsList.new(page)
    end
  end

  def songs_list
    @songs_list
  end

end