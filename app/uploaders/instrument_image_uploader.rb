# encoding: utf-8

class InstrumentImageUploader < CarrierWave::Uploader::Base

  include CarrierWave::RMagick

  def store_dir
    "instruments"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    "http://placehold.it/300x300"
  end

  # Process files as they are uploaded:
#  process :process_original_img

#  def process_original_img
#    resize_to_fill(500, 500)
#  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    "#{model.id}.jpg" if original_filename
  end

end
