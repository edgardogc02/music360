class GroupChallengeDecorator < ChallengeDecorator
  delegate_all

  protected

    def display_start_challenge_to_user?(user)
      user and !model.has_user_played?(user) and UserGroupsManager.new(user).belongs_to_group?(model.group)
    end

end