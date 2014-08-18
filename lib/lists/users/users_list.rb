class UsersList

  def initialize(users=[], title="", display_all_link="")
    @users = users
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

  def users
    @users
  end

end