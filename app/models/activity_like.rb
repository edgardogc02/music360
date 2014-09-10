class ActivityLike < ActiveRecord::Base

  belongs_to :user
  belongs_to :activity, class_name: 'PublicActivity::Activity'

  validate :user_should_like_same_activity_just_once, on: :create

  public

  def self.by_user_and_activity(user, activity)
    ActivityLike.find_by(user: user, activity: activity)
  end

  private

  def user_should_like_same_activity_just_once
    if self.user.activity_likes.where(activity_id: self.activity_id).count > 0
      errors.add :user_id, "You already liked that feed"
    end
  end

end
