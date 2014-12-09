class GroupChallengeDecorator < ChallengeDecorator

  decorates :challenge

  delegate_all

  def view_more_songs_link
    h.group_challenge_songs_path(group_id: model.group_id)
  end

  def change_song_link
    h.group_challenge_songs_path(group_id: model.group_id)
  end

  def display_start_group_challenge_button(label="Accept challenge", size="btn-sm")
    if display_start_challenge_to_user?(h.current_user)
      h.link_to label, start_challenge_url, {class: "btn btn-primary app-play " + size, data: {type: 'Group Challenge by ' + model.group.name , song_name: model.song.title, song_cover: model.song.cover.url, song_writer: model.song.writer, song_publisher: model.song.publisher}}
    end
  end

  def show_description
    if description
      description
    else
      "No description for this challenge yet"
    end
  end

  protected

    def display_start_challenge_to_user?(user)
      user and UserGroupsManager.new(user).belongs_to_group?(model.group) and challenge.open
    end

end