# encoding: utf-8

class UserImagenameUploader < Uploader

  after :store, :update_user_record

  def update_user_record(file)
    model.updated_image = true
    model.save
  end

  def store_dir_folder
    "images_users"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    "default_user.png"
  end

  # Process files as they are uploaded:
  process :process_original_img

  def process_original_img
    resize_to_fill(500, 500)
  end

end
