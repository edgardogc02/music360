class UsersListFactory

  def initialize(type, current_user, page)
    if type == "users"
      @users_list = RegularUsersList.new(current_user, page)
    elsif type == "facebook"
      @users_list = FacebookFriendsList.new(current_user, page)
    elsif type == "following"
      @users_list = FollowedUsersList.new(current_user, page)
    elsif type == "top"
      @users_list = TopUsersList.new(current_user, page)
    end
  end

  def users_list
    @users_list
  end

end