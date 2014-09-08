class User < ActiveRecord::Base

  mount_uploader :imagename, UserImagenameUploader
  mount_uploader :cover, UserCoverUploader

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
  has_many :facebook_friends_groups, through: :facebook_friends, source: :groups

  has_many :user_invitations, dependent: :destroy
  has_many :user_facebook_invitations, dependent: :destroy

  has_many :user_purchased_songs, dependent: :destroy
  has_many :purchased_songs, through: :user_purchased_songs, source: :song

  has_many :payments
  has_many :user_premium_subscriptions

  has_many :initiated_groups, class_name: "Group", foreign_key: "initiator_user_id"
  has_many :user_groups
  has_many :groups, through: :user_groups
  has_many :group_invitations, dependent: :destroy
  has_many :all_groups_invited_to, through: :group_invitations, source: :group
  has_many :group_invitations_not_pending, -> { where("pending_approval IS NULL OR pending_approval = 0") }, class_name: "GroupInvitation", dependent: :destroy
  has_many :group_invitations_pending, -> { where(pending_approval: true) }, class_name: "GroupInvitation", dependent: :destroy
  has_many :groups_invited_to, through: :group_invitations_not_pending, source: :group
  has_many :groups_invited_to_pending, through: :group_invitations_pending, source: :group

  has_many :published_group_posts, class_name: "GroupPost", foreign_key: "publisher_id", dependent: :destroy
  has_many :published_challenge_posts, class_name: "ChallengePost", foreign_key: "publisher_id", dependent: :destroy

  has_many :song_scores

  belongs_to :instrument

  has_many :post_likes

  has_many :post_comments

  has_many :user_level_upgrades

  has_many :user_posts

  before_create { generate_token(:auth_token) }

#  before_create :fill_in_extra_fields

  scope :not_deleted, -> { where('deleted IS NULL OR deleted = 0') }
  scope :by_username_or_email, ->(username_or_email) { where('username LIKE ? OR email LIKE ?', '%'+username_or_email+'%', '%'+username_or_email+'%') }
  scope :not_connected_via_facebook, -> { where('oauth_uid IS NULL') }

  scope :exclude, ->(user_id) { where('users.id_user != ?', user_id) }
  scope :excludes, ->(users_ids) { where('users.id_user NOT IN (?)', users_ids) if users_ids.any? }

  scope :include, ->(user_ids) { where('users.id_user IN (?)', user_ids) }
  scope :search_user_relationships, ->(user) { include(user.user_facebook_friends.pluck(:user_facebook_friend_id) + user.user_followers.pluck(:follower_id) + user.inverse_user_followers.pluck(:user_id) + user.challenges.pluck(:challenged_id) + user.proposed_challenges.pluck(:challenger_id)) }
  scope :order_by_challenges_count, -> { order('challenges_count DESC') }
  scope :premium, -> { where(premium: true) }
  scope :by_xp, -> { order('xp DESC') }

  def likes?(likeable)
    likeable.liked_by?(self)
  end

	def to_s
		username
	end

	def self.lars_willner
	  User.find_by_username("Lars Willner")
	end

  # TODO: Refactor me
	def level
	  if self.xp.blank?
	    user_level = Level.where(xp: 0).first
	    if user_level
	      user_level.title
	    else
	      "Beginner"
	    end
	  else
		  xp_level = Level.where(["xp <= ?", self.xp]).last
		  if xp_level
		    xp_level.title
		  else
		    "Beginner"
		  end
		end
	end

	def get_level
	  if self.xp.blank?
	    user_level = Level.where(xp: 0).first
	    user_level
	  else
		  xp_level = Level.where(["xp <= ?", self.xp]).last
		  xp_level
		end
	end

	def next_level
		Level.where(number: self.get_level.number + 1).first
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

  def update_first_song(song_id)
    self.first_song_id = song_id
    save
  end

  def update_first_challenge(challenge_id)
    self.first_challenge_id = challenge_id
    save
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    EmailNotifier.password_reset(self).deliver
  end

  def change_password(new_password)
    self.password = new_password
    self.password_confirmation = new_password
    if check_password_lenght
      save
    else
      false
    end
  end

  def assign_xp_points(points)
    UserXpPointsUpdate.new(self, points).save
  end

	def completion_percentage_level
		if self.next_level
			a = self.xp - self.get_level.xp
			b = self.next_level.xp - self.get_level.xp.to_f
			percent = a.to_f / b.to_f * 100.0
			if percent < 50
				percent.round
			else
				percent.floor
			end
		end
	end

	private

	def check_password_lenght
    if (self.password.length >= 5 and self.password_confirmation.length >= 5)
      true
    else
      false
    end
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
