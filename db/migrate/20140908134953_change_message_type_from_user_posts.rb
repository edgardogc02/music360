class ChangeMessageTypeFromUserPosts < ActiveRecord::Migration
  def change
    change_column :user_posts, :message, :text
  end
end
