class UserPaidSong < ActiveRecord::Base

  validates :user_id, presence: true
  validates :song_id, presence: true, uniqueness: {scope: :user_id}

  belongs_to :user
  belongs_to :song

  extend FriendlyId

  friendly_id :token

end
