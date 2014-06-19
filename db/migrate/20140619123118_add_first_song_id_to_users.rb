class AddFirstSongIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_song_id, :integer
  end
end
