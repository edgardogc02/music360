class PremiumSongsList < PaginatedSongsList

  include Rails.application.routes.url_helpers

  def initialize(page)
    super(page)
  end

  def display_more?
    false
  end

  def title
    "Featured songs"
  end

  def songs
    @songs ||= Song.featured.page page
  end

end