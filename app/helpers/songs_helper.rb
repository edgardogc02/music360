module SongsHelper

  def display_selected_difficulty_class_attr(difficulty)
    value = 'btn btn-default btn-sm'
    if params[:difficulty] == difficulty
      value << ' active'
    end
    value
  end

end
