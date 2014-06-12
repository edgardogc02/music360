class SongScore < ActiveRecord::Base
  
  validates :user_id, presence: true
  validates :song_id, presence: true
  validates :score, presence: true
  validates :instrument, presence: true

  belongs_to :user
  belongs_to :song
  belongs_to :instrument, foreign_key: :instrument, primary_key: :id

  self.table_name = "songscore"
  
end
