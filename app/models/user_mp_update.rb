class UserMpUpdate < ActiveRecord::Base

  include PublicActivity::Common

  validates :user_id, presence: true
  validates :mp, presence: true

  belongs_to :user

end
