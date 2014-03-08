class Challenge < ActiveRecord::Base
	belongs_to :owner, class_name: "User"
	has_one :opponent, class_name: "User"
	belongs_to :song

	scope :open, -> { where(public: true) }

	def cover_url
		song.cover_url
	end
end
