class ResumedMostChallengedUsersChallengeList < ResumedMostChallengedUsersList

  def initialize(current_user, song_id)
    super(current_user)
    @song = song_id
  end

  def users
    @users ||= UserChallengeDecorator.decorate_collection(current_user.most_challenged_users(20))
  end

  def display_more_link
    list_people_path(view: "users", song_id: @song)
  end

end