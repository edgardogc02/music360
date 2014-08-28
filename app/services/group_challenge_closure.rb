class GroupChallengeClosure

  attr_accessor :challenge

  def initialize(challenge)
    @challenge = challenge
  end

  def close
    assign_extra_xp_points_to_winner
    assign_extra_xp_points_to_challenge_creator
    notify_users_about_results
    challenge.close
  end

  def ammount_of_users_for_points_level_1
    @ammount_of_users_for_points_level_1 ||= 1000
  end

  def set_ammount_of_users_for_points_level_1(val)
    @ammount_of_users_for_points_level_1 = val
  end

  def ammount_of_users_for_points_level_2
    @ammount_of_users_for_points_level_2 ||= 500
  end

  def set_ammount_of_users_for_points_level_2(val)
    @ammount_of_users_for_points_level_2 = val
  end

  def ammount_of_users_for_points_level_3
    @ammount_of_users_for_points_level_3 ||= 100
  end

  def set_ammount_of_users_for_points_level_3(val)
    @ammount_of_users_for_points_level_3 = val
  end

  def ammount_of_users_for_points_level_4
    @ammount_of_users_for_points_level_4 ||= 50
  end

  def set_ammount_of_users_for_points_level_4(val)
    @ammount_of_users_for_points_level_4 = val
  end

  def ammount_of_users_for_points_level_5
    @ammount_of_users_for_points_level_5 ||= 20
  end

  def set_ammount_of_users_for_points_level_5(val)
    @ammount_of_users_for_points_level_5 = val
  end

  def ammount_of_users_for_points_level_6
    @ammount_of_users_for_points_level_6 ||= 5
  end

  def set_ammount_of_users_for_points_level_6(val)
    @ammount_of_users_for_points_level_6 = val
  end

  def ammount_of_users_for_points_level_7
    @ammount_of_users_for_points_level_7 ||= 2
  end

  def set_ammount_of_users_for_points_level_7(val)
    @ammount_of_users_for_points_level_7 = val
  end

  private

  def assign_extra_xp_points_to_winner
    if challenge.has_group_winner?
      if challenge.users_already_played_counter > ammount_of_users_for_points_level_1
        challenge.group_winner.assign_xp_points 50000
      elsif challenge.users_already_played_counter > ammount_of_users_for_points_level_2
        challenge.group_winner.assign_xp_points 25000
      elsif challenge.users_already_played_counter > ammount_of_users_for_points_level_3
        challenge.group_winner.assign_xp_points 20000
      elsif challenge.users_already_played_counter > ammount_of_users_for_points_level_4
        challenge.group_winner.assign_xp_points 15000
      elsif challenge.users_already_played_counter > ammount_of_users_for_points_level_5
        challenge.group_winner.assign_xp_points 10000
      elsif challenge.users_already_played_counter > ammount_of_users_for_points_level_6
        challenge.group_winner.assign_xp_points 5000
      elsif challenge.users_already_played_counter > ammount_of_users_for_points_level_7
        challenge.group_winner.assign_xp_points 2000
      end
    end
  end

  def assign_extra_xp_points_to_challenge_creator
    challenge.challenger.assign_xp_points 1000 if challenge.users_already_played_counter >= 3
  end

  def notify_users_about_results

  end

end