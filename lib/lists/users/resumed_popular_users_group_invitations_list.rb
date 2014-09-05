class ResumedPopularUsersGroupInvitationsList < UsersList

  include Rails.application.routes.url_helpers

  def initialize(group)
    @group = group
    super
  end

  def title
    "Invite your InstrumentChamp Friends"
  end

  def display_more_link
    list_people_path(view: "group_invitation_most_popular", group_id: @group.id)
  end

  def users
    @users ||= UserInvitationDecorator.decorate_collection(User.not_deleted.excludes(@group.user_ids).excludes(@group.invited_users.ids).by_xp.limit(4))
  end

  def group
    @group
  end

end