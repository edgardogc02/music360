class GroupChallengeDecorator < ChallengeDecorator

  decorates :challenge

  delegate_all

  def view_more_songs_link
    h.group_challenge_songs_path(group_id: model.group_id)
  end

  def change_song_link
    h.group_challenge_songs_path(group_id: model.group_id)
  end

  def display_start_group_challenge_button(label="Start challenge")
    if display_start_challenge_to_user?(h.current_user)
      h.link_to label, start_challenge_url, {class: "btn btn-primary btn-sm"}
    end
  end

  protected

    def display_start_challenge_to_user?(user)
      user and UserGroupsManager.new(user).belongs_to_group?(model.group) and challenge.open
    end

end