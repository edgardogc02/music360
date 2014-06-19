class User < ActiveRecord::Base

  mount_uploader :imagename, UserImagenameUploader

  paginates_per 30

	extend FriendlyId

	alias_attribute :id, :id_user

  attr_accessor :just_signup

	friendly_id :username

  attr_accessor :feedback_call

  validates :username, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z0-9@.\-\_\s]+\Z/ }
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

  has_many :user_invitations, dependent: :destroy
  has_many :user_facebook_invitations, dependent: :destroy

  has_many :user_purchased_songs, dependent: :destroy
  has_many :purchased_songs, through: :user_purchased_songs, source: :song

  has_many :payments
  has_many :user_premium_subscriptions

  belongs_to :instrument

  before_create { generate_token(:auth_token) }

#  before_create :fill_in_extra_fields

  scope :not_deleted, -> { where('deleted IS NULL OR deleted = 0') }
  scope :by_username_or_email, ->(username_or_email) { where('username LIKE ? OR email LIKE ?', '%'+username_or_email+'%', '%'+username_or_email+'%') }
  scope :not_connected_via_facebook, -> { where('oauth_uid IS NULL') }

  scope :exclude, ->(user_id) { where('users.id_user != ?', user_id) }

  scope :include, ->(user_ids) { where('users.id_user IN (?)', user_ids) }
  scope :search_user_relationships, ->(user) { include(user.user_facebook_friends.pluck(:user_facebook_friend_id) + user.user_followers.pluck(:follower_id) + user.inverse_user_followers.pluck(:user_id) + user.challenges.pluck(:challenged_id) + user.proposed_challenges.pluck(:challenger_id)) }
  scope :order_by_challenges_count, -> { order('challenges_count DESC') }
  scope :premium, -> { where(premium: true) }

	def to_s
		username
	end

	def level
		"Beginner"
	end

	def just_signup?
	  !self.just_signup.blank?
	end

  def has_instrument_selected?
    !self.instrument_id.blank?
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

  def destroy
    self.deleted = true
    self.deleted_at = Time.now
    save!
  end

  def deleted?
    self.deleted == true
  end

  def increment_challenges_count
    self.challenges_count = self.challenges_count + 1
    save
  end

  def already_installed_desktop_app
    self.installed_desktop_app = true
    save
  end

  def can_receive_messages?
    !UserFacebookAccount.new(self).fake_account?
  end

  def self.generate_new_username_from_string(username)
    i = 0
    orig_username = username

    begin
      if i == 0
        new_username = orig_username
      else
        new_username = orig_username + i.to_s
      end
      i = i + 1
    end while User.exists?(username: new_username)
    new_username
  end

  def can_buy_song?(song)
    song.cost? and !self.purchased_songs.include?(song)
  end

  def is_facebook_user?
    !self.oauth_uid.blank?
  end

  def american?
    countrycode == "US"
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
