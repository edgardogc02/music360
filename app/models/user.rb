class User < ActiveRecord::Base
	has_many :challenges
	has_secure_password

	validates :username, presence: true, uniqueness: true
	validates :password, presence: true, on: :create
	validates :password_confirmation, presence: true, confirmation: true, on: :create

	def to_s
		username
	end
end
