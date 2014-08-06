class AddUploaderUserIdToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :uploader_user_id, :integer
  end
end
