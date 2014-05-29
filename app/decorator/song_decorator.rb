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
      h.link_to "Play", play_url, {class: play_class_attr, id: 'play_song_'+ model.title.squish.downcase.tr(" ","_")}
    end
  end

  def challenge_button(challenged_id="")
    if display_challenge_button?
      h.link_to "Challenge", h.new_challenge_path(song_id: model.id, challenged_id: challenged_id), {id: "challenge_#{model.id}", class: challenge_class_attr}
    end
  end

  def edit_button
    if h.signed_in? and h.current_user.admin?
      h.link_to "Edit", h.edit_song_path(model), {class: 'btn btn-sm btn-default'}
    end
  end

  def buy_button
    if h.signed_in? and h.current_user.admin? and h.current_user.can_buy_song?(model) and model.cost?
      h.link_to "Buy", h.buy_user_paid_song_path(model), {class: 'btn btn-sm btn-default'}
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

  def play_class_attr
    value = 'btn btn-sm btn-default Activation2 Activation2_Play song_'+ model.title.squish.downcase.tr(" ","_")
    if h.signed_in? and h.current_user.installed_desktop_app? and !h.is_mobile?
      value << ' app-play'
    end
    value
  end

  def challenge_class_attr
    'btn btn-sm btn-default Activation2 Activation2_Challenge Activation2_Challenge_Songs'
  end

end