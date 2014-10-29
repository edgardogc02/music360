class CreateWishlistItems < ActiveRecord::Migration
  def change
    create_table :wishlist_items do |t|
      t.integer :wishlist_id
      t.integer :song_id

      t.timestamps
    end
  end
end
