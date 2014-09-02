# encoding: utf-8

class UserCoverUploader < Uploader

  def store_dir_folder
    "cover_images_users"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    "default_cover.png"
  end

  # Process files as they are uploaded:
  process :resize_to_fill => [944, 200]

end
