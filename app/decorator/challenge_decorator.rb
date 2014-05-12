class ChallengeDecorator < Draper::Decorator
  delegate_all

  def start_challenge_url
    if h.signed_in? and h.current_user.installed_desktop_app?
      model.desktop_app_uri
    else
      h.apps_path
    end
  end

  def start_challenge_button
    if model.display_start_challenge_to_user?(h.current_user)
      h.render 'challenges/actions', challenge: model.decorate
    end
  end

  def display_points
    if model.display_points?
      h.render "challenges/points", challenge: model
    end
  end

  def display_winner
    if model.display_winner?
      h.content_tag :div, "Winner: " + winner.username
    end
  end

  def select_opponent_link
    if model.song
      h.link_to select_opponent_link_name, h.for_challenge_people_path(song_id: model.song.id), {class: 'btn btn-link', data: { toggle: "modal", target: "#selectUser"}}
    else
      h.link_to select_opponent_link_name, h.for_challenge_people_path, {class: 'btn btn-link', data: { toggle: "modal", target: "#selectUser" }}
    end
  end

  private

  def select_opponent_link_name
    if model.challenged
      "Change your opponent"
    else
      "Choose your opponent"
    end
  end

end