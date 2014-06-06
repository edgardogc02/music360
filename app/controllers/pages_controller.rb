class PagesController < ApplicationController
  before_action :authorize, except: [:help]

  def home
    users = User.not_deleted.exclude(current_user).search_user_relationships(current_user).limit(4) | User.not_deleted.exclude(current_user).limit(6)
    @users = UserChallengeDecorator.decorate_collection(User.exclude(current_user.id).order_by_challenges_count.limit(4))
    @songs = SongQuickStartDecorator.decorate_collection(Song.not_user_created.free.by_popularity.limit(4))

    @instruments = Instrument.visible

    @top_songs = SongDecorator.decorate_collection(Song.by_popularity.limit(4))
    @top_users = UserChallengeDecorator.decorate_collection(User.all.limit(4))
    @top_artist = Artist.all.limit(4)
  end

end
