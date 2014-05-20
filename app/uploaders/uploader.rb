# encoding: utf-8

class Uploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  def store_dir
    if model.created_by and model.created_by.include?("test-instrumentchamp")
      "test/" + store_dir_folder
    else
      store_dir_folder
    end
  end

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
