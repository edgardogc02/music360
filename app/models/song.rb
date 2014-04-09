class Song < ActiveRecord::Base

  extend FriendlyId

  friendly_id :title, use: :slugged

  validates :title, presence: true
  validates :writer, presence: true
  validates :length, presence: true
  validates :difficulty, presence: true
  validates :arranger_userid, presence: true
  validates :status, presence: true
  validates :onclient, presence: true
  validates :published_at, presence: true

	belongs_to :artist
	belongs_to :category

  has_many :song_ratings, dependent: :destroy

  scope :free, -> { where('cost IS NULL OR cost = 0') }
  scope :by_popularity, -> { joins('LEFT JOIN songratings ON songratings.song_id = songs.id').group('case when songratings.song_id is null then songs.id else songratings.song_id end').order('AVG(songratings.rating) DESC, songs.id') }

	def cover_url
	  cover.blank? ? "http://placehold.it/300x300" : cover
	end

	def song_uri
		# Format: "ic:song=Amazing%20grace.mid"
		"ic:song=#{URI::escape(title)}.mid"
	end
end
