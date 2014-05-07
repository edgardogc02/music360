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
end