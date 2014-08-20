class AddInviterUserIdToGroupInvitations < ActiveRecord::Migration
  def change
    add_column :group_invitations, :inviter_user_id, :integer
  end
end
