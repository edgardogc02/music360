class ChangeActivityLikes < ActiveRecord::Migration
  def change
    add_column :activity_likes, :activity_id, :integer
    remove_column :activity_likes, :likeable_id, :integer
    remove_column :activity_likes, :likeable_type, :string
  end
end
