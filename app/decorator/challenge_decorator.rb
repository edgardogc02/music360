class ChallengeDecorator < Draper::Decorator
  delegate_all

  def start_challenge_url
    if !h.is_mobile?
      if h.signed_in? and h.current_user.installed_desktop_app?
        model.desktop_app_uri + "&user_auth_token=" + h.current_user.auth_token
      else
        h.apps_path
      end
    else
      h.mobile_landing_path
    end
  end

  def display_start_challenge_button
    if display_start_challenge_to_user?(h.current_user)
      h.link_to "Start challenge", start_challenge_url, {class: start_challenge_class_attr, id: "challenge_start_#{model.id}"}
    end
  end

  def display_decline_challenge_button
    if display_decline_challenge_to_user?(h.current_user)
      h.link_to "Decline", h.challenge_path(model), {confirm: "Are you sure?", method: :delete, class: "btn btn-danger pull-left"}
    end
  end

  def display_results
    if display_results?
      h.render "challenges/results", challenge: self
    end
  end

  def select_opponent_link
    if model.song
      h.link_to select_opponent_link_name, h.for_challenge_people_path(song_id: model.song.id), {class: 'btn btn-link', data: { toggle: "modal", target: "#selectUser"}}
    else
      h.link_to select_opponent_link_name, h.for_challenge_people_path, {class: 'btn btn-link', data: { toggle: "modal", target: "#selectUser" }}
    end
  end

  def start_challenge_class_attr
    value = 'btn btn-primary pull-left margin-right'
    if h.signed_in? and h.current_user.installed_desktop_app? and !h.is_mobile?
      value << ' app-play'
    end
    value
  end

  private

  def select_opponent_link_name
    if model.challenged
      "Change your opponent"
    else
      "Choose your opponent"
    end
  end

  def display_start_challenge_to_user?(user)
    user and is_user_involved?(user) and !model.has_user_played?(user)
  end

  def display_decline_challenge_to_user?(user)
    user and !model.has_user_played?(user) and model.is_user_challenged?(user)
  end

  def display_results?
    model.has_challenger_played? or model.has_challenged_played?
  end
end