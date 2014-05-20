# encoding: utf-8

class SongCoverUploader < Uploader

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir_folder
    "songart"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    "default_song.png"
  end

end
