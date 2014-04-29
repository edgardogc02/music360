# encoding: utf-8

class UserImagenameUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  after :store, :update_user_record

  def update_user_record(file)
    model.updated_image = true
    model.save
  end

  # Choose what kind of storage to use for this uploader:
  # storage :ftp # this is setup in the carrierwave.rb initializer file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "images_users"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    "http://placehold.it/300x300"
  end

  # Process files as they are uploaded:
  process :process_original_img

  def process_original_img
    resize_to_fill(500, 500)
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
