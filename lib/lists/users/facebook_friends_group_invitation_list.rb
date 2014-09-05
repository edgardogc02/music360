class FacebookFriendsGroupInvitationList < PaginatedUsersList

  def initialize(current_user, page, group)
    @current_user = current_user
    @group = group
    super(page)
  end

  def title
    "Invite your Facebook friends"
  end

  def display_more?
    false
  end

  def users
    @users ||= UserInvitationDecorator.decorate_collection(current_user.facebook_friends.excludes(@group.user_ids).excludes(@group.invited_users.ids).by_xp.page page)
  end

  def current_user
    @current_user
  end

  def group
    @group
  end

end