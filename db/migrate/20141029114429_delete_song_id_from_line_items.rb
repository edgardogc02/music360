class DeleteSongIdFromLineItems < ActiveRecord::Migration
  def change
    remove_column :line_items, :song_id
  end
end
