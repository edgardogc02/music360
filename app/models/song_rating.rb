class SongRating < ActiveRecord::Base

 validates :user_id, presence: true
 validates :song_id, presence: true
 validates :rating, presence: true

  belongs_to :user
  belongs_to :song

  self.table_name = "songratings"

end
