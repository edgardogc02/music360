class ResumedPopularUsersChallengeList < ResumedPopularUsersList

  def initialize(exclude_user, song_id)
    super(exclude_user)
    @song = song_id
  end

  def users
    @users ||= UserChallengeDecorator.decorate_collection(User.not_deleted.exclude(exclude_user.id).limit(4))
  end
  
  def display_more_link
    list_people_path(view: "users", song_id: @song)
  end

end