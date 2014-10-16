# encoding: utf-8

class MidiUploader < Uploader

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir_folder
    "fataxamlmlsd"
  end

  def extension_white_list
    %w(mid)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  #def filename
  #  original_filename.sub(" ", "_") if original_filename
  #end

end
