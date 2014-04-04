class CreateUserFollowers < ActiveRecord::Migration
  def change
    create_table :user_followers do |t|
      t.integer :user_id, null: false
      t.integer :follower_id, null: false

      t.timestamps
    end
    add_index :user_followers, :user_id
    add_index :user_followers, :follower_id
    add_index :user_followers, [:user_id, :follower_id], unique: true
  end
end
