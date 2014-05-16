class Challenge < ActiveRecord::Base

  validates :challenger_id, presence: true
  validates :challenged_id, presence: true
  validates :song_id, presence: true
  validates :instrument, presence: true
  validates :public, inclusion: {in: [true, false]}

  validate :challenged_and_finished, :on => :create
  validate :no_own_challenge, :on => :create

	belongs_to :challenger, class_name: "User", foreign_key: "challenger_id"
	belongs_to :challenged, class_name: "User", foreign_key: "challenged_id"
	belongs_to :song

  before_create :fill_in_extra_fields

  scope :public, -> { where(public: true) }
  scope :pending_by_challenger, -> { where('score_u1 = 0') }
  scope :pending_by_challenged, -> { where('score_u2 = 0') }
	scope :pending_only_by_challenged, -> { where('score_u1 > 0 and score_u2 = 0') }
  scope :pending_only_by_challenger, -> { where('score_u1 = 0 and score_u2 > 0') }
	scope :finished, -> { where('score_u1 > 0 and score_u2 > 0') }
  scope :default_order, -> { order('created_at DESC') }
  scope :default_limit, -> { limit(3) }

	def cover_url
		song.cover_url
	end

  def desktop_app_uri
    "ic:challenge=#{self.id}"
  end

  def has_challenger_played?
    !self.score_u1.nil? and !self.score_u1.zero?
  end

  def has_challenged_played?
    !self.score_u2.nil? and !self.score_u2.zero?
  end

  def has_user_played?(user)
    (is_user_challenger?(user) and has_challenger_played?) or (is_user_challenged?(user) and has_challenged_played?)
  end

  def is_user_challenger?(user)
    user == self.challenger
  end

  def is_user_challenged?(user)
    user == self.challenged
  end

  def is_user_involved?(user)
    is_user_challenged?(user) or is_user_challenger?(user)
  end

  # TODO: refactor the following 3 methods
  def self.pending_for_user(user, opts={})
    sql = user.challenges.pending_only_by_challenged.to_sql + " UNION " + user.proposed_challenges.pending_only_by_challenger.to_sql
    sql = "SELECT * FROM (#{sql}) a "
    sql << " ORDER BY #{opts[:order].to_sentence} " if opts[:order]
    sql << " LIMIT #{opts[:limit]} " if opts[:limit]

    Challenge.find_by_sql(sql)
  end

  def self.not_played_by_user(user, opts={})
    sql = user.challenges.pending_by_challenger.to_sql + " UNION " + user.proposed_challenges.pending_by_challenged.to_sql

    sql = "SELECT * FROM (#{sql}) a "
    sql << " ORDER BY #{opts[:order].to_sentence} " if opts[:order]
    sql << " LIMIT #{opts[:limit]} " if opts[:limit]

    Challenge.find_by_sql(sql)
  end

  def self.results_for_user(user, opts={})
    sql = user.challenges.finished.to_sql + " UNION " + user.proposed_challenges.finished.to_sql

    sql = "SELECT * FROM (#{sql}) a "
    sql << " ORDER BY #{opts[:order].to_sentence} " if opts[:order]
    sql << " LIMIT #{opts[:limit]} " if opts[:limit]

    Challenge.find_by_sql(sql)
  end

  def challenger_won?
    has_challenger_played? and has_challenged_played? and score_u1 > score_u2
  end

  def challenged_won?
    has_challenger_played? and has_challenged_played? and score_u1 < score_u2
  end

	private

	def challenged_and_finished
    errors.add(:challenged_id, "You already have an open challenge for that song with that user") if Challenge.where(challenger_id: self.challenger_id, challenged_id: self.challenged_id, song_id: self.song_id).where("score_u1 = 0 OR score_u2 = 0").count > 0
	end

  def no_own_challenge
    errors.add(:challenger_id, "You can't challenge your self") if self.challenger and self.challenged and self.challenger == self.challenged
  end

  def fill_in_extra_fields
    self.score_u1 = 0 if self.score_u1.nil?
    self.score_u2 = 0 if self.score_u2.nil?
  end

end
