class SongsList

  def initialize(songs=[], title="", display_all_link="")
    @songs = users
    @title = title
    @display_all_link = display_all_link
  end

  def title
    @title
  end

  def display_more_link
    @display_all_link
  end

  def display_more?
    true
  end

  def paginate?
    false
  end

  def songs
    @songs
  end

end