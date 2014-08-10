# encoding: utf-8

class GroupImagenameUploader < Uploader

  def store_dir_folder
    "images_groups"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    "default_group.png"
  end

end
