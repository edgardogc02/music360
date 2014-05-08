class ChallengeDecorator < Draper::Decorator
  delegate_all

  def desktop_app_uri
    if h.signed_in? and h.current_user.installed_desktop_app?
      super
    else
      h.apps_path
    end
  end

  def display_start_challenge
    if model.display_start_challenge_to_user?(h.current_user)
      h.link_to "Start challenge", desktop_app_uri, {class: "btn btn-primary", id: "challenge_start_#{model.id}"}
    end
  end

  def display_points
    if model.display_points?
      h.render "points", challenge: model
    end
  end

  def display_winner
    if model.display_winner?
      h.content_tag :div, "Winner: " + winner.username
    end
  end

  def select_opponent_link_name
    if model.challenged
      "Change your opponent"
    else
      "Choose your opponent"
    end
  end
end