class SongDecorator < Draper::Decorator

  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def display_play_button?
    !paid? or ( h.signed_in? and h.current_user.purchased_songs.include?(self) )
  end

  def display_challenge_button?
    true
  end

  def play_button
    if display_play_button?
      h.action_button(play_url, 'Play', {class: play_class_attr, id: play_id_attr, data: {song_id: model.id, song_name: model.title}}, 'glyphicon glyphicon-play')
    end
  end

  def challenge_button(params)
    if display_challenge_button?
      h.action_button(h.new_challenge_path(song_id: model.id, challenged_id: params[:challenged_id]), 'Challenge', {class: challenge_class_attr, id: "challenge_#{model.id}", data: {song_id: model.id, song_name: model.title}})
    end
  end

  def edit_button
    if h.signed_in? and h.current_user.admin?
      h.action_button(h.edit_admin_song_path(model), 'Edit')
    end
  end

  def buy_button
    if h.signed_in? and h.current_user.admin? and h.current_user.can_buy_song?(model) and model.cost?
      h.action_button(h.buy_user_purchased_song_path(model), 'Buy', {id: "buy_song_#{model.id}"})
    end
  end

  def play_url
    if !h.is_mobile?
      if h.signed_in? and h.current_user.installed_desktop_app?
        url = model.desktop_app_uri + "&user_auth_token=#{h.current_user.auth_token}"
        if h.current_user.has_instrument_selected?
          url = url + "&instrument_id=#{h.current_user.instrument_id.to_s}"
        end
        url
      else
        h.apps_path + "?song_id=#{model.id}"
      end
    else
      h.mobile_landing_path
    end
  end

  def play_id_attr
    'play_song_'+ model.title.squish.downcase.tr(" ","_")
  end

  def play_class_attr
    value = 'activation2 activation2_play song_'+ model.title.squish.downcase.tr(" ","_")
    if h.signed_in? and h.current_user.installed_desktop_app? and !h.is_mobile?
      value << ' app-play'
    end
    value
  end

  def challenge_class_attr
    'btn btn-sm btn-primary activation2 activation2_challenge_songs'
  end

  def display_rating
    h.render 'songs/rating', rating: model.rating
  end

  def display_difficulty
  	case model.difficulty
		when 3
		  "Hard"
		when 2
		  "Medium"
		when 1
		  "Easy"
		else
		  "-"
		end
  end

end