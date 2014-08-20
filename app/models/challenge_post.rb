class ChallengePost < ActiveRecord::Base

  include PublicActivity::Common

  validates :challenge_id, presence: true
  validates :publisher_id, presence: true
  validates :message, presence: true

  belongs_to :challenge
  belongs_to :publisher, class_name: 'User', foreign_key: 'publisher_id'

end
