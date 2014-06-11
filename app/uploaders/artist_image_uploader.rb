# encoding: utf-8

class ArtistImageUploader < Uploader

  def store_dir_folder
    "images_artists"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    "default_artist.png"
  end

end
