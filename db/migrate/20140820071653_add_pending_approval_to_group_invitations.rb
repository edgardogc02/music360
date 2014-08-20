class AddPendingApprovalToGroupInvitations < ActiveRecord::Migration
  def change
    add_column :group_invitations, :pending_approval, :boolean
  end
end
