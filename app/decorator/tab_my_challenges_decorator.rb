class TabMyChallengesDecorator < ChallengesDecorator

  def title
    "My challenges"
  end

  def tab_id
    "my_challenges"
  end

  def active?
    false
  end

  def tab_text
    "My challenges"
  end

  def all_challenges_link
    h.list_challenges_path(view: "my_challenges")
  end

  def no_challenges_message
    "You don't have challenges right now"
  end
end