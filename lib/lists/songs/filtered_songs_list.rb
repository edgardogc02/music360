class FilteredSongsList < PaginatedSongsList

  def initialize(params)
    @difficulty = params[:difficulty]
    super(params[:page])
  end

  def difficulty
    @difficulty
  end

  def filtered_songs
    songs = Song.all
    songs = Song.easy if difficulty == 'easy'
    songs = Song.medium if difficulty == 'medium'
    songs = Song.hard if difficulty == 'hard'
    songs
  end

end