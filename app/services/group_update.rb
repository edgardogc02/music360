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

  private

  def save_activity
    actions_to_log.each do |action|
      @group.create_activity action , owner: @updater_user, group_id: @group.id
    end
  end

  def actions_to_log
    actions = []
    actions << :update_description if @group.previous_changes.include?(:description)
    actions << :update_imagename if @group.previous_changes.include?(:imagename)
    actions << :update_cover if @group.previous_changes.include?(:cover)
    actions
  end

end