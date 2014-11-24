class EchonestArtist

  attr_accessor :artist

  def initialize(name, top=0)
    @title = name.titleize
    @top = top
  end

  def title
    @title
  end

  def bio
    @bio ||= Echowrap.artist_biographies(name: self.title, results: 2, start: 1, license: "cc-by-sa").first if Echowrap.artist_biographies(name: title)
  end

  def image
    @image ||= Echowrap.artist_images(name: self.title).first
  end

  def twitter
    @image ||= Echowrap.artist_twitter(name: self.title).twitter
  end

  def save_artist_to_db
    unless self.artist = Artist.find_by_title(title)

      self.artist = Artist.create(title: title, top: @top)

      self.artist.download_echonest_image

      if bio
        self.artist.bio = bio.text[0..1000]
        self.artist.bio_read_more_link = bio.url
      end

      if twitter
        self.artist.twitter = twitter
      end

      self.artist.save!
      ArtistFakeUser.new(self.artist).create_fake_user
    end
  end

end