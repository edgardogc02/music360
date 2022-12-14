class Group < ActiveRecord::Base

  include PublicActivity::Common

  mount_uploader :imagename, GroupImagenameUploader

  validates :name, presence: true
  validates :group_privacy_id, presence: true

  belongs_to :group_privacy
  belongs_to :initiator_user, class_name: "User"

  has_many :user_groups
  has_many :users, through: :user_groups
  has_many :group_invitations, dependent: :destroy
  has_many :invited_users, through: :group_invitations, source: :user
  has_many :posts, class_name: "GroupPost", dependent: :destroy

  has_many :challenges

  scope :public, -> { where(group_privacy: GroupPrivacy.public) }
  scope :closed, -> { where(group_privacy: GroupPrivacy.closed) }
  scope :secret, -> { where(group_privacy: GroupPrivacy.secret) }
  scope :searchable, -> { where('group_privacy_id IN (?)', [GroupPrivacy.public.id, GroupPrivacy.closed.id]) }
  scope :by_name, ->(name) { where('name LIKE ?', '%'+name+'%') }
  scope :by_creation_date, -> { order('groups.created_at DESC') }

  scope :by_popularity, -> { joins(:user_groups).group('user_groups.group_id').order('COUNT(*) DESC') }
  scope :not_secret, -> { where.not(group_privacy: GroupPrivacy.secret) }

  def secret?
    group_privacy == GroupPrivacy.secret
  end

  def public?
    group_privacy == GroupPrivacy.public
  end

  def closed?
    group_privacy == GroupPrivacy.closed
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

  def assign_xp_to_owner_after_new_member_joins
    if self.users.count == 2
      self.initiator_user.assign_xp_points(1000)
    elsif self.users.count == 10
      self.initiator_user.assign_xp_points(5000)
    elsif self.users.count == 50
      self.initiator_user.assign_xp_points(10000)
    elsif self.users.count == 200
      self.initiator_user.assign_xp_points(20000)
    elsif self.users.count == 500
      self.initiator_user.assign_xp_points(25000)
    elsif self.users.count == 1000
      self.initiator_user.assign_xp_points(50000)
    end
  end

end
