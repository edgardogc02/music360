class UserLevelUpgrade < ActiveRecord::Base

  include PublicActivity::Common

  validates :user_id, presence: true
  validates :level_id, presence: true

  belongs_to :user
  belongs_to :level

end
