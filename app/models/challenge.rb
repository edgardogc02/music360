class Challenge < ActiveRecord::Base
	belongs_to :owner, class_name: "User", foreign_key: "user1"
	has_one :opponent, class_name: "User", foreign_key: "user2"
	belongs_to :song

	scope :open, -> { where(public: true) }

	def cover_url
		song.cover_url
	end
end
