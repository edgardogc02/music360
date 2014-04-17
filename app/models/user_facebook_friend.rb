class UserFacebookFriend < ActiveRecord::Base

  validates :user_id, presence: true, uniqueness: {scope: :user_facebook_friend_id}
  validates :user_facebook_friend_id, presence: true

  belongs_to :user
  belongs_to :facebook_friend, class_name: "User", foreign_key: 'user_facebook_friend_id'

end
