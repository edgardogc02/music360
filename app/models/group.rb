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

  scope :public, -> { where(group_privacy: GroupPrivacy.public) }
  scope :closed, -> { where(group_privacy: GroupPrivacy.closed) }
  scope :secret, -> { where(group_privacy: GroupPrivacy.secret) }
  scope :searchable, -> {where('group_privacy_id IN (?)', [GroupPrivacy.public.id, GroupPrivacy.closed.id])}
  scope :by_name, ->(name) { where('name LIKE ?', '%'+name+'%') }
  
  scope :by_popularity, -> { order('created_at DESC') } #TODO

  def secret?
    group_privacy == GroupPrivacy.secret
  end

  def user_can_post?(user)
    group_privacy == GroupPrivacy.public or
    group_privacy == GroupPrivacy.closed or
    (group_privacy == GroupPrivacy.secret and user.groups.include?(self))
  end

end
