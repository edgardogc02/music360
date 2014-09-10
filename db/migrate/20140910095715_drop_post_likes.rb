class DropPostLikes < ActiveRecord::Migration
  def change
    drop_table :post_likes
  end
end
