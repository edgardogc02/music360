class EchonestArtist

  include Rails.application.routes.url_helpers

  def initialize(name)
    @name = name
    @title = name.titleize
  end

  def title
    @title
  end
  
  def songs
    false
  end

  def challenges
    false
  end

  def bio
    @bio ||= Echowrap.artist_biographies(name: name, results: 2, start: 1, license: "cc-by-sa").first
  end

  def name
    @name
  end
  
  def public_image_url
    @public_image_url ||= Echowrap.artist_images(name: name, results: 1).first
  end
  
  def imagename_url
    false
  end

end