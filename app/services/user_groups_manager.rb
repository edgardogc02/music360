class UserGroupsManager

  attr_accessor :user

  def initialize(user)
    @user = user
  end


  def user
    @user
  end

  def add_to_group(group)

  end

  def belongs_to_group?(group)
    user.group_ids.include?(group.id)
  end

  def invited_to_group?(group)
    user.all_groups_invited_to.include?(group)
  end

end