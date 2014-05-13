class TabPendingChallengesDecorator < ChallengesDecorator

  def title
    "Pending"
  end

  def tab_id
    "pending"
  end

  def tab_text
    "Pending"
  end

  def all_challenges_link
    h.list_challenges_path(view: "pending")
  end

  def no_challenges_message
    "No open challenges right now"
  end
end