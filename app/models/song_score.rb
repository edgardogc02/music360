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

  has_many :activities, class_name: 'PublicActivity::Activity', as: :trackable

  scope :best_scores, -> { select('*, MAX(score) AS max_score').group('user_id, instrument').order('max_score DESC').includes(:user) }
  scope :highest_scores, ->(limit) { select('*, MAX(score) AS max_score').group('user_id, instrument').order('max_score DESC').includes(:user).limit(limit) }
  scope :by_score, -> { order('score DESC') }

  public

  def self.highest_score
    self.by_score.first
  end

  def position_in_the_world
    @position_in_the_world ||= SongScore.where('score > ?', self.score).where(song_id: self.song_id).count + 1
  end

  def position_in_challenge
    @group_challenge_position ||= SongScore.where('score > ?', self.score).where(challenge_id: self.challenge_id).count + 1
  end
end
