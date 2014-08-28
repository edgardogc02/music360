class SongScore < ActiveRecord::Base

  include PublicActivity::Common

  self.table_name = "songscore"

  validates :user_id, presence: true
  validates :song_id, presence: true
  validates :score, presence: true
  validates :instrument, presence: true

  belongs_to :user
  belongs_to :song
  belongs_to :instrument, foreign_key: :instrument, primary_key: :id
  belongs_to :challenge

  scope :best_scores, -> { select('*, MAX(score) AS max_score').group('user_id, instrument').order('max_score DESC').includes(:user) }
  scope :by_score, -> { order('score DESC') }

  def self.highest_score
    self.by_score.first
  end

end
