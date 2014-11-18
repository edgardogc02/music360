class ArtistDecorator < Draper::Decorator

  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
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