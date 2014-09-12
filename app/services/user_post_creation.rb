class UserPostCreation

  attr_accessor :user_post

  def initialize(user_post)
    @user_post = user_post
  end

  def activity
    @activity
  end

  def save
    if @user_post.save
      save_activity
      true
    else
      false
    end
  end

  def save_activity
    @activity = @user_post.create_activity :create, owner: @user_post.user
  end

end