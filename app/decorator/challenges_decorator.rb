class ChallengesDecorator < Draper::CollectionDecorator

  def title
    "Challenges"
  end

  def tab_id
    ""
  end

  def tab_class
    res = "tab-pane "
    res << " active" if active?
    res
  end

  def active?
    false
  end

  def tab_text
    ""
  end

  def view_all_link
    h.link_to "View all", all_challenges_link, {class: "btn btn-primary pull-right btn-sm"}
  end

  def all_challenges_link
    "#"
  end

  def no_challenges_message
    "No challenges to show right now"
  end
end