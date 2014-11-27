class ArtistDecorator < Draper::Decorator

  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def display_challenge_button?
    h.signed_in? and model.user != h.current_user
  end

  def challenge_button(song_id="")
    if display_challenge_button?
      user.decorate.challenge_button(song_id, {artist_id: model.id})
    end
  end

  def display_follow_button?
    true
  end

  def display_follow_button
    if display_follow_button?
      user.decorate.display_follow_button
    end
  end

  def image
    h.link_to h.artist_path(model) do
    	h.image_tag(image_url, {alt: model.title, class: 'thumbnail'})
    end
  end

  def image_url
    if model.imagename.present?
      model.imagename_url
    elsif model.echonest_image
      model.echonest_image.url
    else
      model.imagename_url
    end
  end

  def edit_button
    if h.signed_in? and h.current_user.admin?
      h.action_button(h.edit_admin_artist_path(model), 'Edit')
    end
  end

end