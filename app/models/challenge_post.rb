class ChallengePost < ActiveRecord::Base

  include PublicActivity::Common

  validates :challenge_id, presence: true
  validates :publisher_id, presence: true
  validates :message, presence: true

  belongs_to :challenge
  belongs_to :publisher, class_name: 'User', foreign_key: 'publisher_id'

  has_many :likes, class_name: 'PostLike', as: :likeable
  has_many :likers, through: :likes, source: :user

  has_many :comments, class_name: 'PostComment', as: :commentable

  public

  def liked_by?(user)
    likers.include?(user)
  end

end
