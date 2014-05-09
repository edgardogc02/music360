class CreateUserInvitations < ActiveRecord::Migration
  def change
    create_table :user_invitations do |t|
      t.integer :user_id
      t.string :friend_email

      t.timestamps
    end
  end
end
