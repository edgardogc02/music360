class User < ActiveRecord::Base
	extend FriendlyId

	alias_attribute :id, :id_user

	friendly_id :username

#	has_many :challenges
	belongs_to :people_category
	has_secure_password

	validates :username, presence: true, uniqueness: true
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

	private

	def send_confirmation_email
#    EmailNotifier.send_user_confirmation(self).deliver
	end

end
