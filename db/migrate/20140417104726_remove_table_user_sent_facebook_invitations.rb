class RemoveTableUserSentFacebookInvitations < ActiveRecord::Migration
  def change
    drop_table :user_sent_facebook_invitations
  end
end
