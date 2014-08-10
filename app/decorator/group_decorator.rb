class GroupDecorator < Draper::Decorator

  delegate_all

  def invite_users_button
    if h.signed_in? and h.current_user == model.initiator_user
      h.link_to "Invite users", h.group_group_invitations_path(self), {class: "btn btn-primary"}
    end
  end

  def join_button
    if h.signed_in? and !UserGroupsManager.new(h.current_user).belongs_to_group?(model)
      h.link_to "Join", h.join_group_path(model), {class: "btn btn-primary"}
    end
  end

  def edit_button
    if h.signed_in? and h.current_user == model.initiator_user
      h.link_to "Edit", h.edit_group_path(model), {class: "btn btn-primary"}
    end
  end

end