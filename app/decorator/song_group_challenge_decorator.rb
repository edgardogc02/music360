class SongGroupChallengeDecorator < SongChallengeDecorator

  def challenge_button(params)
    if display_challenge_button?
      h.action_button(h.new_group_challenge_path(Group.find(params[:group_id]), song_id: model.id), 'Challenge', {class: challenge_class_attr, id: "challenge_#{model.id}", data: {song_id: model.id, song_name: model.title}})
    end
  end

end