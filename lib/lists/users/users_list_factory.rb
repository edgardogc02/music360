class UsersListFactory

  def initialize(type, current_user, page, group_id)
    if type == "users"
      @users_list = RegularUsersList.new(current_user, page)
    elsif type == "facebook"
      @users_list = FacebookFriendsList.new(current_user, page)
    elsif type == "group_invitation_facebook"
      @users_list = FacebookFriendsGroupInvitationList.new(current_user, page, Group.find(group_id.to_i))
    elsif type == "group_invitation_most_popular"
      @users_list = PopularUsersGroupInvitationsList.new(page, Group.find(group_id.to_i))
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