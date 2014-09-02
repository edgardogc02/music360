class Level < ActiveRecord::Base

  validates :title, presence: true
  validates :xp, presence: true

  def self.top_level_score
		Level.order('xp DESC').first.xp
  end

end
