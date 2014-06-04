class SongDecorator < Draper::Decorator

  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def display_play_button?
    true
  end

  def display_challenge_button?
    true
  end

  def play_button
    if display_play_button?
      h.action_button(play_url, 'Play', {class: play_class_attr, id: play_id_attr}, 'glyphicon glyphicon-play')
    end
  end

  def challenge_button(challenged_id="")
    if display_challenge_button?
      h.action_button(h.new_challenge_path(song_id: model.id, challenged_id: challenged_id), 'Challenge', {class: challenge_class_attr, id: "challenge_#{model.id}"})
    end
  end

  def edit_button
    if h.signed_in? and h.current_user.admin?
      h.action_button(h.edit_song_path(model), 'Edit', {class: play_class_attr, id: play_id_attr})
    end
  end

  def buy_button
    if h.signed_in? and h.current_user.admin? and h.current_user.can_buy_song?(model) and model.cost?
      h.action_button(h.buy_user_paid_song_path(model), 'Buy', {id: "buy_song_#{model.id}"})
    end
  end

  def play_url
    if !h.is_mobile?
      if h.signed_in? and h.current_user.installed_desktop_app?
        if h.current_user.has_instrument_selected?
          model.desktop_app_uri + "&instrument_id=" + h.current_user.instrument_id.to_s
        else
          model.desktop_app_uri
        end
      else
        h.apps_path
      end
    else
      h.mobile_landing_path
    end
  end

  def play_id_attr
    'play_song_'+ model.title.squish.downcase.tr(" ","_")
  end

  def play_class_attr
    value = 'Activation2 Activation2_Play song_'+ model.title.squish.downcase.tr(" ","_")
    if h.signed_in? and h.current_user.installed_desktop_app? and !h.is_mobile?
      value << ' app-play'
    end
    value
  end

  def challenge_class_attr
    'btn btn-sm btn-primary Activation2 Activation2_Challenge Activation2_Challenge_Songs'
  end

end