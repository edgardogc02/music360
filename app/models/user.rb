class User < ActiveRecord::Base
	extend FriendlyId

	friendly_id :username

	has_many :challenges
	belongs_to :people_category
	has_secure_password

	validates :username, presence: true, uniqueness: true
	validates :password, presence: true, on: :create
	validates :password_confirmation, presence: true, confirmation: true, on: :create

	def to_s
		username
	end
end
