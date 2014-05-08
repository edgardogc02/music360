class SongDecorator < Draper::Decorator

  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def desktop_app_uri
    if h.signed_in? and h.current_user.installed_desktop_app?
      super
    else
      h.apps_path
    end
  end

  def display_play_button?
    true
  end

  def display_challenge_button?
    true
  end

  def play_button
    if display_play_button?
      h.link_to "Play", self.desktop_app_uri, {class: 'btn btn-sm btn-default'}
    end
  end

  def challenge_button(challenged_id="")
    if display_challenge_button?
      h.link_to "Challenge", h.new_challenge_path(song_id: model.id, challenged_id: challenged_id), {id: "challenge_#{model.id}", class: 'btn btn-sm btn-default'}
    end
  end

  def edit_button
    if h.signed_in? and h.current_user.admin?
      h.link_to "Edit", edit_song_path(model), {class: 'btn btn-sm btn-default'}
    end
  end

end