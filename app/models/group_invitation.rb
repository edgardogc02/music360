class GroupInvitation < ActiveRecord::Base

  belongs_to :group
  belongs_to :user
  belongs_to :inviter_user, class_name: 'User', foreign_key: 'inviter_user_id'

  scope :by_group, ->(group_id) { where(group_id: group_id) }
  scope :pending_approval, -> { where(pending_approval: true) }

end
