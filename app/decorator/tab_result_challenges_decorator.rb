class TabResultChallengesDecorator < ChallengesDecorator

  def title
    "Results"
  end

  def tab_id
    "results"
  end

  def tab_text
    "Results"
  end

  def all_challenges_link
    h.list_challenges_path(view: "results")
  end

  def no_challenges_message
    "No challenges right now"
  end
end