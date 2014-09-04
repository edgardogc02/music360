class UserXpPointsUpdate

  def initialize(user, points)
    @user = user
    @points = points
  end

  def save
    level_before = @user.level
    @user.xp = @user.xp + @points
    level_after = @user.level

    if level_before != level_after
      create_new_user_level_upgrade
      save_activity
    end

    @user.save
  end

  private

  def create_new_user_level_upgrade
    new_level = Level.where(["xp <= ?", @user.xp]).last
    @user.user_level_upgrades.create(level: new_level)
  end

  def save_activity
    @user.user_level_upgrades.last.create_activity :create, owner: @user
  end

end