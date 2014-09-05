class ResumedFacebookFriendsGroupInvitationList < UsersList

  include Rails.application.routes.url_helpers

  def initialize(current_user, group)
    @current_user = current_user
    @group = group
    super
  end

  def title
    "Invite your Facebook friends"
  end

  def display_more_link
    list_people_path(view: "group_invitation_facebook", group_id: @group.id)
  end

  def users
    @users ||= UserInvitationDecorator.decorate_collection(current_user.facebook_friends.excludes(@group.user_ids).excludes(@group.invited_users.ids).by_xp.limit(4))
  end

  def current_user
    @current_user
  end

  def group
    @group
  end

end