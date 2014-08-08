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

end