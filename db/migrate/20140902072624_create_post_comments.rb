class CreatePostComments < ActiveRecord::Migration
  def change
    create_table :post_comments do |t|
      t.integer :commentable_id
      t.string :commentable_type
      t.integer :user_id
      t.text :comment

      t.timestamps
    end
  end
end
