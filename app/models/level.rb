class Level < ActiveRecord::Base

  validates :title, presence: true
  validates :xp, presence: true

  has_many :user_level_upgrades

  def self.top_level_score
		Level.order('xp DESC').first.xp
  end

end
