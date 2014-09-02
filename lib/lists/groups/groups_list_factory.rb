class GroupsListFactory

  def initialize(type, current_user, page)
    if type == "my_groups"
      @groups_list = MyGroupsList.new(current_user)
    elsif type == "most_popular"
      @groups_list = MostPopularGroupsList.new(page, current_user)
    elsif type == "new"
      @groups_list = NewGroupsList.new(page, current_user)
    end
  end

  def groups_list
    @groups_list
  end

end