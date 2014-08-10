class Group < ActiveRecord::Base

  mount_uploader :imagename, GroupImagenameUploader

  validates :name, presence: true
  validates :group_privacy_id, presence: true

  belongs_to :group_privacy
  belongs_to :initiator_user, class_name: "User"

  has_many :user_groups
  has_many :users, through: :user_groups
  has_many :group_invitations, dependent: :destroy

  scope :public, -> { where(group_privacy: GroupPrivacy.public) }
  scope :closed, -> { where(group_privacy: GroupPrivacy.closed) }
  scope :secret, -> { where(group_privacy: GroupPrivacy.secret) }

  def secret?
    group_privacy == GroupPrivacy.secret
  end

end
