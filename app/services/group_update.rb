class GroupUpdate

  attr_accessor :group

  def initialize(group, updater_user)
    @group = group
    @updater_user = updater_user
  end

  def save(params)
    if @group.update_attributes(params)
      save_activity
      true
    else
      false
    end
  end

  def save_activity
    if @group.previous_changes.include?(:description)
      @group.create_activity :update_description, owner: @updater_user, group_id: @group.id
    end
  end

end