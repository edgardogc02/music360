class Songscore < ActiveRecord::Base

  self.table_name = "songscore"

  belongs_to :challenge
  belongs_to :user

end
