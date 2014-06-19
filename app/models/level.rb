class Level < ActiveRecord::Base

  validates :title, presence: true
  validates :xp, presence: true

end
