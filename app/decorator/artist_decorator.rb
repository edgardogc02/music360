class ArtistDecorator < Draper::Decorator

  delegate_all

  def edit_button
    if h.signed_in? and h.current_user.admin?
      h.action_button(h.edit_admin_artist_path(model), 'Edit')
    end
  end

end