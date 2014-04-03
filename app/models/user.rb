class User < ActiveRecord::Base
	extend FriendlyId

	alias_attribute :id, :id_user

	friendly_id :username

#	has_many :challenges
	belongs_to :people_category
	has_secure_password
	has_many :user_omniauth_credentials, dependent: :destroy

  has_many :user_sent_facebook_invitations, dependent: :destroy

#	validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
	validates :password, presence: true, on: :create
	validates :password_confirmation, presence: true, confirmation: true, on: :create

  after_create :send_confirmation_email

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

end
