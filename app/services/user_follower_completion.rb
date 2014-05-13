class UserFollowerCompletion
  attr_accessor :user_follower

  def initialize(user_follower)
    @user_follower = user_follower
  end

  def save
    if user_follower.save
      send_followed_user_message
    end
  end

  def send_followed_user_message
    if user_follower.followed.can_receive_messages?
      EmailNotifier.followed_user_message(user_follower).deliver
    end
  end
end