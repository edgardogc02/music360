class CreateUserSentFacebookInvitations < ActiveRecord::Migration
  def change
    create_table :user_sent_facebook_invitations do |t|
      t.integer :user_id, null: false
      t.string :user_facebook_id, null: false

      t.timestamps
    end
  end
end
