class UserDecorator < Draper::Decorator

  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def display_follow_button?
    true
  end

  def display_follow_button
    if display_follow_button?
      if h.current_user.following?(user)
        h.render 'users/unfollow', user: model, size: "btn-sm"
      else
        h.render 'users/follow', user: model, size: "btn-sm"
      end
    end
  end

  def challenge_button(song_id="")
    if display_challenge_button?
      h.action_button(h.new_challenge_path(song_id: song_id, challenged_id: user.id), 'Challenge', {class: 'activation2 activation2_challenge activation2_challenge_users', id: "challenge_#{user.id}", data: {user_id: model.id}})
    end
  end

  def invite_to_group?
    false
  end

  def display_challenge_button?
    h.signed_in? and model != h.current_user
  end

  def invite_to_group(group_id="")
    if invite_to_group? and group_id and h.signed_in? and !UserGroupsManager.new(model).belongs_to_group?(Group.find(group_id.to_i))
      h.render "group_invitations/form", user_id: model.id, group: Group.find(group_id.to_i)
    end
  end

end