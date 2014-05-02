class User < ActiveRecord::Base

  mount_uploader :imagename, UserImagenameUploader

  paginates_per 20

	extend FriendlyId

	alias_attribute :id, :id_user

	friendly_id :username

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :password, presence: true, on: :create
  validates :password_confirmation, presence: true, confirmation: true, on: :create

#  validate :validate_maximum_image_size # TODO: sometimes doesn't work with ftp server and throws a read exception

  attr_accessor :skip_emails

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

  belongs_to :instrument

  before_create { generate_token(:auth_token) }

  before_create :fill_in_extra_fields

  scope :not_deleted, -> { where('deleted IS NULL OR deleted = 0') }
  scope :by_username_or_email, ->(username_or_email) { where('username LIKE ? OR email LIKE ?', '%'+username_or_email+'%', '%'+username_or_email+'%') }
  scope :not_connected_via_facebook, -> { where('oauth_uid IS NULL') }
  scope :exclude, ->(user_id) { where('users.id_user != ?', user_id) }

  def sign_up(ip)
    self.ip = ip
    save
    send_welcome_email
  end

	def to_s
		username
	end

	def level
		"Test"
	end

	def avatar_url
		"http://placehold.it/300x300"
	end

  def self.from_omniauth(auth, ip)
    user = User.where(email: auth.info.email).first

    if user.nil?
      user = User.create_from_omniauth(auth)
      user.ip = ip
      user.save
      user.remote_imagename_url = user.remote_facebook_image if user.facebook_credentials
      user.save

      user.send_welcome_email
    else
      user.user_omniauth_credentials.create_or_update_from_omniauth(auth)
    end
    user
  end

  def remote_facebook_image
    "https://graph.facebook.com/" + facebook_credentials.oauth_uid.to_s + "/picture?type=large"
  end

  def following?(followed_user)
    self.inverse_user_followers.find_by(user_id: followed_user.id)
  end

  def follow(followed_user)
    self.inverse_user_followers.create(user_id: followed_user.id)
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

  def facebook_top_friends(limit)
    self.facebook.fql_query("SELECT uid, name FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 = me()) ORDER BY mutual_friend_count DESC LIMIT #{limit}")
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

  def send_welcome_email
    if !self.new_record? and !self.skip_emails # avoid callbacks otherwise the tests and fake facebook users will send emails
      EmailNotifier.welcome_message(self).deliver
    end
  end

	private

  def fill_in_extra_fields
    self.confirmed = Time.now
    self.installed_desktop_app = 0
    self.premium = true
    self.premium_until = 3.months.from_now
    self.updated_image = 0
  end

	def self.create_from_omniauth(auth)
    user = User.new
    user.first_name = auth.info.first_name
    user.last_name = auth.info.last_name
    user.username = auth.info.name
    user.email = auth.info.email
    user.password = User.generate_random_password(5)
    user.password_confirmation = user.password
    user.oauth_uid = auth.uid
    user.save!

    user.user_omniauth_credentials.create_from_omniauth(auth)

    user
	end

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
