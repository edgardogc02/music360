class CreatePostLikes < ActiveRecord::Migration
  def change
    create_table :post_likes do |t|
      t.integer :likeable_id
      t.string :likeable_type

      t.timestamps
    end
  end
end
