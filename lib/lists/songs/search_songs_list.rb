class SearchSongsList < PaginatedSongsList

  include Rails.application.routes.url_helpers

  def initialize(display_premium, search_value, page)
    @display_premium = display_premium
    @search_value = search_value
    super(page)
  end

  def title
    "Songs"
  end

  def display_more?
    false
  end

  def display_premium?
    @display_premium
  end

  def search_value
    @search_value
  end

  def songs
    if display_premium?
      @songs = Song.not_user_created.by_title(search_value).page(page)
    else
      @songs = Song.not_user_created.by_title(search_value).page(page)
    end
  end

  def paginate?
    true
  end

end