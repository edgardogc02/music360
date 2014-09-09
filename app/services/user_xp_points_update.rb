class UserXpPointsUpdate

  attr_accessor :user

  def initialize(user, points)
    @user = user
    @points = points
  end

  def save
    level_before = @user.level
    @user.xp = @user.xp + @points
    level_after = @user.level


    create_new_user_level_upgrade if level_before != level_after
    create_new_user_mp_updates

    @user.save
  end

  private

  def create_new_user_level_upgrade
    new_level = Level.where(["xp <= ?", @user.xp]).last
    @user.user_level_upgrades.create(level: new_level)
    save_level_upgrade_activity
  end

  def save_level_upgrade_activity
    @user.user_level_upgrades.last.create_activity :create, owner: @user
  end

  def create_new_user_mp_updates
    user.user_mp_updates.create(mp: @points)
    save_mp_update_activity
  end

  def save_mp_update_activity
    user.user_mp_updates.last.create_activity :create, owner: @user
  end

end