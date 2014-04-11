class Challenge < ActiveRecord::Base

  validates :challenger_id, presence: true
  validates :challenged_id, presence: true
  validates :song_id, presence: true
  validates :instrument, presence: true
  validates :public, inclusion: {in: [true, false]}
  validates :finished, inclusion: {in: [true, false]}

  validate :challenged_and_finished

	belongs_to :challenger, class_name: "User", foreign_key: "challenger_id"
	belongs_to :challenged, class_name: "User", foreign_key: "challenged_id"
	belongs_to :song

  scope :public, -> { where(public: true) }
	scope :open, -> { where(finished: false) }

	def cover_url
		song.cover_url
	end

  def desktop_app_uri
    "ic:ch=#{self.id}"
  end

	private

	def challenged_and_finished
    errors.add(:finished, "You already have an open challenge for that song with that user") if Challenge.where(challenged_id: self.challenged_id, song_id: self.song_id, finished: false).count > 0
	end

end
