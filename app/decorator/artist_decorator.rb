class ArtistDecorator < Draper::Decorator

  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def image
    h.link_to h.artist_path(model), class: 'thumbnail' do
      if model.imagename_url != model.imagename.default_url
        h.image_tag(model.imagename_url, {alt: model.title})
      elsif model.public_image_url
        h.image_tag(model.public_image_url.url, {alt: model.title})
      else
        h.image_tag(model.imagename_url, {alt: model.title})
      end
    end
  end

  def edit_button
    if h.signed_in? and h.current_user.admin?
      h.action_button(h.edit_admin_artist_path(model), 'Edit')
    end
  end

end