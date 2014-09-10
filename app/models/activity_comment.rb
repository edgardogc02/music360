class ActivityComment < ActiveRecord::Base

  validates :user_id, presence: true
  validates :comment, presence: true

  belongs_to :activity, class_name: 'PublicActivity::Activity'
  belongs_to :user

end
