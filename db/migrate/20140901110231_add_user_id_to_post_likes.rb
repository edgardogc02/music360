class AddUserIdToPostLikes < ActiveRecord::Migration
  def change
    add_column :post_likes, :user_id, :integer
  end
end
