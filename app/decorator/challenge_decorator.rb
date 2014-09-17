class ChallengeDecorator < Draper::Decorator

  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end

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
      h.link_to "Accept challenge", start_challenge_url, {class: start_challenge_class_attr, id: "challenge_start_#{model.id}", data: {type: 'Challenge', song_name: model.song.title, song_cover: model.song.cover.url, song_writer: model.song.writer, song_publisher: model.song.publisher}}
    end
  end

  def display_decline_challenge_button
    if display_decline_challenge_to_user?(h.current_user)
      h.link_to "Decline", h.challenge_path(model), {data: {confirm: "Are you sure?"}, method: :delete, class: "btn btn-primary pull-left"}
    end
  end

  def display_remind_button
    if display_remind_button?
      h.link_to "Remind on facebook", h.new_facebook_friend_message_modal_path(challenge_id: model.id), {remote: true, class: "btn btn-warning btn-sm"}
    end
  end

  def display_results
    if display_results?
      h.render "challenges/results", challenge: self
    end
  end

  def select_opponent_path
    if model.song
      h.for_challenge_people_path(song_id: model.song.id)
    else
      h.for_challenge_people_path
    end
  end

  def select_opponent_link
    h.link_to select_opponent_link_name, select_opponent_path, {data: { toggle: "modal", target: "#selectUser"}}
  end

  def start_challenge_class_attr
    value = 'btn btn-primary btn-sm'
    if h.signed_in? and h.current_user.installed_desktop_app? and !h.is_mobile?
      value << ' app-play'
    end
    value
  end

  def view_more_songs_link
    h.for_challenge_songs_path(challenged_id: model.challenged_id)
  end

  def change_song_link
    h.for_challenge_songs_path(challenged_id: model.challenged_id)
  end

  def status
    if has_challenger_played? and has_challenged_played?
      "Finished"
    else
      "Pending"
    end
  end

  def show_winner
    if display_results?
      if model.challenger_won?
        h.concat "Winner: "
        h.link_to model.challenger.username, h.person_path(model.challenger)
      elsif model.challenged_won?
        h.concat "Winner: "
        h.link_to model.challenged.username, h.person_path(model.challenged)
      end
    end
  end

  protected

  def display_start_challenge_to_user?(user)
    user and is_user_involved?(user) and !model.has_user_played?(user)
  end

  private

  def select_opponent_link_name
    if model.challenged
      "Change your opponent"
    else
      "Choose your opponent"
    end
  end

  def display_decline_challenge_to_user?(user)
    user and !model.has_user_played?(user) and model.is_user_challenged?(user)
  end

  def display_remind_button?
    model.challenged and
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