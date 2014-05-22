class UserFacebookFriend < ActiveRecord::Base

  validates :user_id, presence: true, uniqueness: {scope: :user_facebook_friend_id}
  validates :user_facebook_friend_id, presence: true

  belongs_to :user
  belongs_to :facebook_friend, class_name: "User", foreign_key: 'user_facebook_friend_id'

  def self.friends?(first_user, second_user)
    self.where(user_id: first_user.id, user_facebook_friend_id: second_user.id).count > 0
  end

end
