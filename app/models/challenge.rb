class Challenge < ActiveRecord::Base

  validates :user1, presence: true
  validates :user2, presence: true
  validates :song_id, presence: true
  validates :instrument, presence: true
  validates :public, inclusion: {in: [true, false]}
  validates :finished, inclusion: {in: [true, false]}

	belongs_to :challenger, class_name: "User", foreign_key: "user1"
	belongs_to :challenged, class_name: "User", foreign_key: "user2"
	belongs_to :song

  scope :public, -> { where(public: true) }
	scope :open, -> { where(finished: false) }

	def cover_url
		song.cover_url
	end
end
