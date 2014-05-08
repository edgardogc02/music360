class ResumedPopularUsersChallengeList < ResumedPopularUsersList

  def initialize(exclude_user)
    super(exclude_user)
  end

  def users
    @users ||= UserChallengeDecorator.decorate_collection(User.not_deleted.exclude(exclude_user.id).limit(4))
  end

end