# encoding: utf-8

class InstrumentImageUploader < Uploader

  def store_dir_folder
    "instruments"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    "http://placehold.it/300x300"
  end

end
