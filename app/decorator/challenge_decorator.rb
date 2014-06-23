class ChallengeDecorator < Draper::Decorator
  delegate_all

  def start_challenge_url
    if !h.is_mobile?
      if h.signed_in? and h.current_user.installed_desktop_app?
        model.desktop_app_uri + "&user_auth_token=" + h.current_user.auth_token
      else
        h.apps_path + "?challenge_id=#{model.id}"
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
      h.link_to "Decline", h.challenge_path(model), {data: {confirm: "Are you sure?"}, method: :delete, class: "btn btn-primary pull-left"}
    end
  end

  def display_remind_button
    if display_remind_button?
      h.link_to "Remind on facebook", h.new_facebook_friend_message_modal_path(challenge_id: model.id), {remote: true, class: "btn btn-warning"}
    end
  end

  def display_results
    if display_results?
      #h.render "challenges/results", challenge: self
      true
    end
  end

  def select_opponent_path
    if model.song
      h.for_challenge_people_path(song_id: model.song.id)
    else
      h.for_challenge_people_path
    end
  end
  
  def select_song_path
    if model.challenged
      h.for_challenge_songs_path(challenged_id: model.challenged.id)
    else
      h.for_challenge_songs_path
    end
  end

  def select_opponent_link
    h.link_to select_opponent_link_name, select_opponent_path, {class: 'btn btn-primary btn-sm new-challenge-link', data: { toggle: "modal", target: "#selectUser"}}
  end
  
  def select_song_link
    h.link_to select_song_link_name, select_song_path, {class: 'btn btn-primary btn-sm new-challenge-link', data: { toggle: "modal", target: "#selectSong"}}
  end

  def start_challenge_class_attr
    value = 'btn btn-primary btn-sm'
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
  
  def select_song_link_name
    if model.song
      "Change your challenge"
    else
      "Choose your challenge"
    end
  end

  def display_start_challenge_to_user?(user)
    user and is_user_involved?(user) and !model.has_user_played?(user)
  end

  def display_decline_challenge_to_user?(user)
    user and !model.has_user_played?(user) and model.is_user_challenged?(user)
  end

  def display_remind_button?
    has_challenger_played? and
    !has_challenged_played? and
    challenge.created_at <= 1.days.ago and
    h.signed_in? and
    UserFacebookAccount.new(h.current_user).connected? and
    UserFacebookFriend.friends?(model.challenger, model.challenged)
  end

  def display_results?
    model.has_challenger_played? or model.has_challenged_played?
  end
end