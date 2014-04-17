class CreateUserFacebookFriends < ActiveRecord::Migration
  def change
    create_table :user_facebook_friends do |t|
      t.integer :user_id
      t.integer :user_facebook_friend_id

      t.timestamps
    end
    add_index :user_facebook_friends, :user_id
    add_index :user_facebook_friends, :user_facebook_friend_id
  end
end
