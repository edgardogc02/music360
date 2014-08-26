class ArtistDecorator < Draper::Decorator

  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def image
    h.link_to h.artist_path(model) do
      if model.imagename_url != model.imagename.default_url
        h.image_tag(model.imagename_url, {alt: model.title, class: 'thumbnail'})
      elsif model.echonest_image
        h.image_tag(model.echonest_image.url, {alt: model.title, class: 'thumbnail'})
      else
        h.image_tag(model.imagename_url, {alt: model.title, class: 'thumbnail'})
      end
    end
  end

  def edit_button
    if h.signed_in? and h.current_user.admin?
      h.action_button(h.edit_admin_artist_path(model), 'Edit')
    end
  end

end