class GroupPostCreation

  attr_accessor :group_post

  def initialize(group_post, creator_user)
    @group_post = group_post
    @creator_user = creator_user
  end

  def activity
    @activity
  end

  def save
    if @group_post.save
      save_activity
      true
    else
      false
    end
  end

  def save_activity
    @activity = @group_post.create_activity :create, owner: @creator_user, group_id: @group_post.group.id
  end

end