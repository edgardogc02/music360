class User < ActiveRecord::Base

  mount_uploader :imagename, UserImagenameUploader

  paginates_per 20

	extend FriendlyId

	alias_attribute :id, :id_user

  attr_accessor :just_signup

	friendly_id :username

  validates :username, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z0-9@.\-\_\s]+\Z/ }
  validates :email, presence: true, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :password, presence: true, on: :create
  validates :password_confirmation, presence: true, confirmation: true, on: :create

#  validate :validate_maximum_image_size # TODO: sometimes doesn't work with ftp server and throws a read exception

  attr_accessor :skip_emails, :request

	has_many :challenges, foreign_key: "challenger_id"
  has_many :proposed_challenges, class_name: "Challenge", foreign_key: "challenged_id"

	belongs_to :user_category
	has_secure_password
	has_many :user_omniauth_credentials, dependent: :destroy

  has_many :user_followers, dependent: :destroy
  has_many :inverse_user_followers, class_name: "UserFollower", foreign_key: "follower_id"

  has_many :followers, through: :user_followers, source: :follower
  has_many :followed_users, through: :inverse_user_followers, source: :followed

  has_many :user_facebook_friends, dependent: :destroy
  has_many :facebook_friends, through: :user_facebook_friends, source: :facebook_friend

  has_many :user_invitations, dependent: :destroy
  has_many :user_facebook_invitations, dependent: :destroy

  belongs_to :instrument

  before_create { generate_token(:auth_token) }

#  before_create :fill_in_extra_fields

  scope :not_deleted, -> { where('deleted IS NULL OR deleted = 0') }
  scope :by_username_or_email, ->(username_or_email) { where('username LIKE ? OR email LIKE ?', '%'+username_or_email+'%', '%'+username_or_email+'%') }
  scope :not_connected_via_facebook, -> { where('oauth_uid IS NULL') }
  scope :exclude, ->(user_id) { where('users.id_user != ?', user_id) }

	def to_s
		username
	end

	def level
		"Beginner"
	end

	def avatar_url
		"http://placehold.it/300x300"
	end

	def just_signup?
	  !self.just_signup.blank?
	end

  def has_instrument_selected?
    !self.instrument_id.blank?
  end

  def remote_facebook_image
    "https://graph.facebook.com/" + facebook_credentials.oauth_uid.to_s + "/picture?type=large"
  end

  def facebook_uid
    if self.facebook_credentials
      facebook_credentials.oauth_uid
    elsif fake_facebook_user?
      self.email[0, self.email.index("@")]
    else
      ""
    end
  end

  def following?(followed_user)
    self.inverse_user_followers.find_by(user_id: followed_user.id)
  end

  def follow(followed_user)
    user_follower = self.inverse_user_followers.build(user_id: followed_user.id)
    UserFollowerCompletion.new(user_follower).save
  end

  def unfollow(followed_user)
    self.inverse_user_followers.find_by(user_id: followed_user.id).destroy
  end

  def facebook
    @facebook ||= Koala::Facebook::API.new(facebook_credentials.oauth_token)
  end

  def facebook_credentials
    self.user_omniauth_credentials.find_by(provider: 'facebook')
  end

  def twitter_credentials
    self.user_omniauth_credentials.find_by(provider: 'twitter')
  end

  def facebook_top_friends(limit=0)
    sql = "SELECT uid, name FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 = me()) ORDER BY mutual_friend_count DESC"
    if limit > 0
      sql = sql + " LIMIT #{limit}"
    end
    self.facebook.fql_query(sql)
  end

  def has_facebook_credentials?
    !facebook_credentials.nil?
  end

  def destroy
    self.deleted = true
    self.deleted_at = Time.now
    save!
  end

  def deleted?
    self.deleted == true
  end

  def groupies_to_connect_with
    self.facebook_friends
  end

  def already_installed_desktop_app
    self.installed_desktop_app = true
    save
  end

  def can_receive_messages?
    !fake_facebook_user?
  end

  def fake_facebook_user?
    self.email.include? "@fakeuser.com"
  end

  def connected_with_facebook?
    fake_facebook_user? || has_facebook_credentials?
  end

	private

	def self.generate_random_password(length)
    (Digest::SHA1.hexdigest("--#{Time.now.to_s}--"))[0..length]
	end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def validate_maximum_image_size
    if !self.imagename.blank?
      image = Magick::Image::read(self.imagename.path).first
      if image.rows > 1024 or image.columns > 1024
        errors.add :imagename, "should be 1024x1024px maximum!"
      end
    end
  end

end
