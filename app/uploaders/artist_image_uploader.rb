# encoding: utf-8

class ArtistImageUploader < Uploader

  def store_dir_folder
    "images_artists"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    "default_artist.png"
  end
  
  # Process files as they are uploaded:
  process :resize_to_fill => [200, 200]
  
end
