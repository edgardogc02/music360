class UserFollower < ActiveRecord::Base

  validates :user_id, presence: true, uniqueness: {scope: :follower_id}
  validates :follower_id, presence: true
  validate :cant_follow_yourself

  belongs_to :followed, class_name: "User", foreign_key: 'user_id'
  belongs_to :follower, class_name: "User"

  private

  def cant_follow_yourself
    errors.add(:user_id, "You can't follow yourself") if user_id == follower_id
  end

end
