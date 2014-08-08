class GroupCreation

  attr_accessor :group

  def initialize(group)
    @group = group
  end

  def save
    if group.save
      group.initiator_user.user_groups.create(group: group)
      true
    else
      false
    end
  end

end