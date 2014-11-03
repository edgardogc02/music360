class SongDecorator < Draper::Decorator

  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def display_play_button?
    if h.signed_in?
      !paid? or ( h.signed_in? and h.current_user.purchased_songs.include?(self) ) or ( h.current_user.premium? and model.premium? )
    end
  end

  def display_buy_button?
    if h.signed_in? and h.current_user.premium? and model.premium?
      false
    else
      h.signed_in? and h.current_user.can_buy_song?(model) and model.cost?
    end
  end

  def display_challenge_button?
    if h.signed_in?
      !paid? or ( h.signed_in? and h.current_user.purchased_songs.include?(self) ) or ( h.current_user.premium? and model.premium? )
    end
  end

  def play_button
    if display_play_button?
      h.action_button(play_url, 'Play', {class: play_class_attr, id: play_id_attr, data: {type: '', song_id: model.id, song_name: model.title, song_cover: model.cover.url, song_writer: model.writer, song_publisher: model.publisher}}, 'glyphicon glyphicon-play')
    end
  end

  def practice_button
    if display_play_button?
    	h.link_to 'Practice', play_url, {class: play_class_attr + " btn btn-default", id: play_id_attr, data: {type: '', song_id: model.id, song_name: model.title, song_cover: model.cover.url, song_writer: model.writer, song_publisher: model.publisher}}
    end
  end

  def challenge_button(params, size="")
    if display_challenge_button?
    	h.link_to 'Challenge', h.new_challenge_path(song_id: model.id, challenged_id: params[:challenged_id]), {class: challenge_class_attr + " " + size, id: "challenge_#{model.id}", data: {song_id: model.id, song_name: model.title}}
    end
  end

  def edit_button
    if h.signed_in? and h.current_user.admin?
      h.link_to h.edit_admin_song_path(model), class: 'btn btn-sm btn-default' do
        h.content_tag :i, nil, class: "glyphicon glyphicon-pencil"
      end
    end
  end

  def buy_button(size="")
    if display_buy_button?
      h.link_to "#", {class: "btn btn-info btn-big-icon " + size, id: "buy_song_#{model.id}", data: {toggle: "modal", target: "#checkout_modal"}} do
        h.content_tag :i, nil, class: "glyphicon glyphicon-shopping-cart"
      end
    end
  end

  def add_to_wishlist_button(size="")
    if display_buy_button?
      if !h.current_user.current_wishlist.songs.include?(model)
        h.render 'wishlist_items/new', {song: model, size: size}
      else
        h.render 'wishlist_items/disabled', {song: model, size: size}
      end
    end
  end

  def add_to_cart_button(size="")
    if display_buy_button?
      if !h.current_user.current_cart.songs.include?(model)
        h.render 'cart_items/new', {song: model, size: size}
      else
        h.render 'cart_items/disabled', {song: model, size: size}
      end
    end
  end

  def buy_button_redirect
    if display_buy_button?
      h.link_to 'Buy', h.song_path(id: model, buy: true), {class: "btn btn-primary btn-sm"}
    end
  end

  def show_cost
    if display_buy_button?
      h.number_to_euro(model.cost)
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
    'btn btn-primary activation2 activation2_challenge_songs action_button'
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