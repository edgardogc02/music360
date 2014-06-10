class SongScore < ActiveRecord::Base

 validates :user_id, presence: true
 validates :song, presence: true
 validates :score, presence: true

  belongs_to :user
  belongs_to :song, primary_key: "song", foreign_key: "title"

  self.table_name = "songscore"

end
