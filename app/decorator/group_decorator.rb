class GroupDecorator < Draper::Decorator

  delegate_all

  def add_members_button
    if h.signed_in? and h.current_user == model.initiator_user
      h.link_to h.group_group_invitations_path(self), {class: "btn btn-primary"} do
        h.concat h.content_tag :i, "", {class: "glyphicon glyphicon-plus"}
        h.concat " Add members"
      end
    end
  end

  def join_button
    if h.signed_in? and !UserGroupsManager.new(h.current_user).belongs_to_group?(model)
      h.link_to "Join", h.join_group_path(model), {class: "btn btn-primary"}
    end
  end

  def create_challenge_button
    if h.signed_in? and UserGroupsManager.new(h.current_user).belongs_to_group?(model)
      h.link_to "Create challenge", h.new_group_challenge_path(model), {class: "btn btn-primary", id: "new_group_challenge"}
    end
  end

  def edit_button
    if h.signed_in? and h.current_user == model.initiator_user
      h.link_to "Edit", h.edit_group_path(model), role: "menuitem", tabindex: "-1"
    end
  end

  def show_description
    if model.description.blank?
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut accumsan feugiat eleifend. Fusce lobortis felis velit. Etiam accumsan mi in malesuada venenatis. Maecenas sollicitudin sagittis eros. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos."
    else
      model.description
    end
  end

end