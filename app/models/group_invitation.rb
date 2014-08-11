class GroupInvitation < ActiveRecord::Base

  belongs_to :group
  belongs_to :user

  scope :by_group, ->(group_id) { where(group_id: group_id) }

end
