class UserFollowerCompletion
  attr_accessor :user_follower

  def initialize(user_follower)
    @user_follower = user_follower
  end

  def save
    if user_follower.save
      save_xp_points
      send_followed_user_message
    end
  end

  private

    def send_followed_user_message
      if user_follower.followed.can_receive_messages?
        EmailNotifier.followed_user_message(user_follower).deliver
      end
    end

    def save_xp_points
      user_follower.follower.assign_xp_points 50
      user_follower.followed.assign_xp_points 100
    end

end