class GroupCreation

  attr_accessor :group

  def initialize(group, request)
    @group = group
    @request = request
  end

  def save
    group.created_by = @request.host
    if group.save
      group.initiator_user.user_groups.create(group: group)
      true
    else
      false
    end
  end

end