class Song < ActiveRecord::Base

  mount_uploader :cover, SongCoverUploader
  mount_uploader :midi, MidiUploader

  attr_accessor :currency

  paginates_per 30

  extend FriendlyId

  friendly_id :title, use: :slugged

  validates :title, presence: true
  validates :writer, presence: true
  validates :length, presence: true
  validates :difficulty, presence: true
  validates :arranger_userid, presence: true
  validates :status, presence: true
  validates :published_at, presence: true

	belongs_to :artist
	belongs_to :category

  has_many :song_ratings, dependent: :destroy
  has_many :song_scores, dependent: :destroy

  has_many :line_items, as: :buyable
  has_many :wishlist_item, dependent: :destroy

  has_many :redeem_codes, as: :redeemable

  scope :by_title, ->(title) { where('title LIKE ?', '%'+title+'%') }
  scope :free, -> { where('(cost IS NULL OR cost = 0) AND (user_created IS NULL OR user_created = 0)') }
  scope :paid, -> { where('cost > 0') }
  scope :by_popularity, -> { joins('LEFT JOIN songratings ON songratings.song_id = songs.id').group('case when songratings.song_id is null then songs.id else songratings.song_id end').order('AVG(songratings.rating) DESC, songs.id') }
  scope :by_published_at, -> { order('published_at DESC') }
  scope :not_user_created, -> { where('user_created IS NULL OR user_created = 0') }
  scope :user_created, -> { where('user_created = 1') }
  scope :created_by_user_id, ->(user_id) { where('user_created = 1 AND uploader_user_id = ?', user_id) }

  scope :easy, -> { where(difficulty: 1) }
  scope :medium, -> { where(difficulty: 2) }
  scope :hard, -> { where(difficulty: 3) }
  scope :accessible_for_premium_subscription, -> { where(premium: true) }

  has_many :activities, through: :song_scores

	def desktop_app_uri
		# Format: "ic:song=Amazing%20grace.mid"
		"ic:song=#{URI::escape(title)}.mid"
	end

  def paid?
    self.cost > 0
  end

  def top_scores
    self.song_scores.order('score DESC')
  end

  def self.for_new_autogenerated_challenge_lars
    Song.where(id: 2).first || Song.free.first # house of the rising sun
  end

  def self.for_new_autogenerated_challenge_magnus
    Song.where(id: 530).first || Song.free.first # house of the rising sun
  end

  def rating
    if !self.song_ratings.empty?
      self.song_ratings.average("rating").round
    else
      0
    end
  end

  def players
		self.song_scores.count
  end

  # TODO: MOVE THIS TO THE DB. THERE SHOULD BE A NEW TABLE CALLED PREMIUM_SONGS WITH COST AND CURRENCY
  def currency
    "EUR"
  end

end
