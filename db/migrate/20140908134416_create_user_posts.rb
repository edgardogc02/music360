class CreateUserPosts < ActiveRecord::Migration
  def change
    create_table :user_posts do |t|
      t.integer :user_id
      t.integer :message

      t.timestamps
    end
  end
end
