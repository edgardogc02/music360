class Challenge < ActiveRecord::Base

  validates :user1, presence: true
  validates :user2, presence: true
  validates :song_id, presence: true
  validates :instrument, presence: true
  validates :public, inclusion: {in: [true, false]}
  validates :finished, inclusion: {in: [true, false]}

  validate :challenged_and_finished

	belongs_to :challenger, class_name: "User", foreign_key: "user1"
	belongs_to :challenged, class_name: "User", foreign_key: "user2"
	belongs_to :song

  scope :public, -> { where(public: true) }
	scope :open, -> { where(finished: false) }

	def cover_url
		song.cover_url
	end

	private

	def challenged_and_finished
    errors.add(:finished, "You already have an open challenge for that song with that user") if Challenge.where(user2: self.user2, song_id: self.song_id, finished: false).count > 0
	end

end
