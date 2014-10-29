class RemoveSongIdFromWishlists < ActiveRecord::Migration
  def change
    remove_column :wishlists, :song_id
  end
end
