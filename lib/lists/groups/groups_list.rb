class GroupsList

  def initialize(groups=[], title="", display_all_link="")
    @groups = groups
    @title = title
    @display_all_link = display_all_link
  end

  def title
    @title
  end

  def display_more_link
    @display_all_link
  end

  def display_more?
    true
  end

  def paginate?
    false
  end

  def groups
    @groups
  end

end