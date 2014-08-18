class Group < ActiveRecord::Base

  include PublicActivity::Common

  mount_uploader :imagename, GroupImagenameUploader
  mount_uploader :cover, GroupCoverUploader

  validates :name, presence: true
  validates :group_privacy_id, presence: true

  belongs_to :group_privacy
  belongs_to :initiator_user, class_name: "User"

  has_many :user_groups
  has_many :users, through: :user_groups
  has_many :group_invitations, dependent: :destroy
  has_many :posts, class_name: "GroupPost", dependent: :destroy

  has_many :challenges

  scope :public, -> { where(group_privacy: GroupPrivacy.public) }
  scope :closed, -> { where(group_privacy: GroupPrivacy.closed) }
  scope :secret, -> { where(group_privacy: GroupPrivacy.secret) }
  scope :searchable, -> {where('group_privacy_id IN (?)', [GroupPrivacy.public.id, GroupPrivacy.closed.id])}
  scope :by_name, ->(name) { where('name LIKE ?', '%'+name+'%') }

  scope :by_popularity, -> { joins(:user_groups).group('user_groups.group_id').order('COUNT(*) DESC') }

  def secret?
    group_privacy == GroupPrivacy.secret
  end

  def leader_users(limit=0)
    leader_users = users.by_xp
    leader_users = leader_users.limit(limit) if limit > 0
    leader_users
  end

  def user_can_see_posts?(user)
    group_privacy == GroupPrivacy.public or
    group_privacy == GroupPrivacy.closed or
    (group_privacy == GroupPrivacy.secret and user.groups.include?(self))
  end

  def user_can_post?(user)
    user.groups.include?(self)
  end

end
