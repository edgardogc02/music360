class PopularUsersGroupInvitationsList < PaginatedUsersList

  def initialize(page, group)
    @group = group
    super(page)
  end

  def title
    "Invite your InstrumentChamp Friends"
  end

  def display_more?
    false
  end

  def users
    @users ||= UserInvitationDecorator.decorate_collection(User.not_deleted.excludes(@group.user_ids).excludes(@group.invited_users.ids).by_xp.page page)
  end

  def group
    @group
  end

end