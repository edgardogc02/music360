class UserPaidSong < ActiveRecord::Base

  validates :user_id, presence: true
  validates :song_id, presence: true, uniqueness: {scope: :user_id}

  belongs_to :user
  belongs_to :song

  before_create { generate_token(:token) }

  extend FriendlyId

  friendly_id :token

  private

  # TODO: THIS METHOD IS DUPLICATED ALSO IN USER.RB SO THIS COULD BE ETRACTED TO A MODULE
  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while UserPaidSong.exists?(column => self[column])
  end

end
