# encoding: utf-8

class GroupCoverUploader < Uploader

  def store_dir_folder
    "cover_images_groups"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    "default_cover_group.png"
  end
  
  # Process files as they are uploaded:
  process :process_original_img

  def process_original_img
    resize_to_fill(944, 200)
  end

end
