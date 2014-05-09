class CreateUserFacebookInvitations < ActiveRecord::Migration
  def change
    create_table :user_facebook_invitations do |t|
      t.integer :user_id
      t.string :facebook_user_id

      t.timestamps
    end
  end
end
