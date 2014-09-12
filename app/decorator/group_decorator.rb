class GroupDecorator < Draper::Decorator

  delegate_all

  def add_members_button
    if h.signed_in? and UserGroupsManager.new(h.current_user).belongs_to_group?(model)
      h.link_to h.modal_group_group_invitations_path(self), {id: "invite_members", class: "btn btn-default", data: { toggle: "modal", target: "#invite_new_members_modal"}} do
        #h.concat h.content_tag :i, "", {class: "glyphicon glyphicon-plus"}
        h.concat "Invite members"
      end
    end
  end

  def join_button
    if h.signed_in? and !UserGroupsManager.new(h.current_user).belongs_to_group?(model) and
      (!model.secret? or (model.secret? and h.current_user.groups_invited_to.include?(model))) and
      (!model.closed? or (model.closed? and !h.current_user.groups_invited_to_pending.include?(model)))
      h.action_button(h.join_group_path(model), 'Join', {}, 'glyphicon glyphicon-plus')
    end
  end

  def join_toggle_button
    if h.signed_in? and !UserGroupsManager.new(h.current_user).belongs_to_group?(model) and
      (!model.secret? or (model.secret? and h.current_user.groups_invited_to.include?(model))) and
      (!model.closed? or (model.closed? and !h.current_user.groups_invited_to_pending.include?(model)))
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

  def membership_requests_pending_approval_button
    if h.signed_in? and h.current_user == model.initiator_user
      h.link_to "Membership requests", h.pending_approval_group_group_invitations_path(model), role: "menuitem", tabindex: "-1"
    end
  end

  def leave_group_button
    if h.signed_in? and UserGroupsManager.new(h.current_user).belongs_to_group?(model)
      h.link_to "Leave group", h.user_group_path(h.current_user.user_groups.where(group_id: model.id).first), method: :delete, role: "menuitem", tabindex: "-1"
    end
  end

  def show_description
    if model.description.blank?
      "This is an InstrumentChamp group. You can share information and challenge your friends."
    else
      model.description
    end
  end

end