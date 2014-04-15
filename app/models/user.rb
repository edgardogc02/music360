class User < ActiveRecord::Base

  paginates_per 20

	extend FriendlyId

	alias_attribute :id, :id_user

	friendly_id :username

	has_many :challenges, foreign_key: "challenger_id"
  has_many :proposed_challenges, class_name: "Challenge", foreign_key: "challenged_id"

	belongs_to :people_category
	has_secure_password
	has_many :user_omniauth_credentials, dependent: :destroy

  has_many :user_sent_facebook_invitations, dependent: :destroy

  has_many :user_followers, dependent: :destroy
  has_many :inverse_user_followers, class_name: "UserFollower", foreign_key: "follower_id"

  has_many :followers, through: :user_followers, source: :follower
  has_many :followed_users, through: :inverse_user_followers, source: :followed

#	validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
	validates :password, presence: true, on: :create
	validates :password_confirmation, presence: true, confirmation: true, on: :create

  before_create { generate_token(:auth_token) }

  after_create :send_confirmation_email

  scope :not_deleted, -> { where('deleted IS NULL OR deleted = 0') }

	def to_s
		username
	end

	def level
		"Test"
	end

	def avatar_url
		"http://placehold.it/300x300"
	end

  def self.from_omniauth(auth)
    user = User.where(email: auth.info.email).first

    if user.nil?
      user = User.create_from_omniauth(auth)
    else
      user.user_omniauth_credentials.create_or_update_from_omniauth(auth)
    end
    user
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

	private

	def send_confirmation_email
#    EmailNotifier.send_user_confirmation(self).deliver
	end

	def self.create_from_omniauth(auth)
    user = User.new
    user.username = auth.info.name
    user.email = auth.info.email
    user.password = User.generate_random_password(5)
    user.password_confirmation = user.password
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

end
