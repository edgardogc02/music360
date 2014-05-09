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
  belongs_to :winner, class_name: "User", foreign_key: "winner"
	belongs_to :song

  before_create :fill_in_extra_fields

  scope :public, -> { where(public: true) }
	scope :open, -> { where(finished: false) }
	scope :has_result, -> { where.not(winner: nil) }

	def cover_url
		song.cover_url
	end

  def desktop_app_uri
    "ic:challenge=#{self.id}"
  end

  def display_start_challenge_to_user?(user)
    user and (self.challenger == user or self.challenged == user) and !self.finished
  end

  def display_points?
    self.finished
  end

  def display_winner?
    self.finished and !self.winner.blank?
  end

	private

	def challenged_and_finished
    errors.add(:finished, "You already have an open challenge for that song with that user") if Challenge.where(challenger_id: self.challenger_id, challenged_id: self.challenged_id, song_id: self.song_id, finished: false).count > 0
	end

  def fill_in_extra_fields
    self.score_u1 = 0
    self.score_u2 = 0
  end

end
