class GroupChallengeDecorator < ChallengeDecorator

  decorates :challenge

  delegate_all

  def view_more_songs_link
    h.group_challenge_songs_path(group_id: model.group_id)
  end

  def change_song_link
    h.group_challenge_songs_path(group_id: model.group_id)
  end

  def display_start_challenge_to_user?(user)
    user and is_user_involved?(user) and UserGroupsManager.new(user).belongs_to_group?(model.group)
  end

  protected

    def display_start_challenge_to_user?(user)
      user and !model.has_user_played?(user) and UserGroupsManager.new(user).belongs_to_group?(model.group)
    end

end