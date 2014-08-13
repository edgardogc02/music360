class GroupDecorator < Draper::Decorator

  delegate_all

  def add_members_button
    if h.signed_in? and h.current_user == model.initiator_user
      h.link_to h.group_group_invitations_path(self), {class: "btn btn-primary"} do
        h.concat h.content_tag :i, "", {class: "glyphicon glyphicon-plus"}
        h.concat " Add Members"
      end
    end
  end

  def join_button
    if h.signed_in? and !UserGroupsManager.new(h.current_user).belongs_to_group?(model)
      h.link_to "Join", h.join_group_path(model), {class: "btn btn-primary"}
    end
  end

  def edit_button
    if h.signed_in? and h.current_user == model.initiator_user
      h.link_to "Edit", h.edit_group_path(model), role: "menuitem", tabindex: "-1"
    end
  end

end