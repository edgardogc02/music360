class PagesController < ApplicationController
  before_action :authorize, except: [:help]

  def home
    users = User.not_deleted.exclude(current_user).search_user_relationships(current_user).limit(4) | User.not_deleted.exclude(current_user).limit(4)
    @users = UserChallengeDecorator.decorate_collection(users.take(4))
    @songs = SongQuickStartDecorator.decorate_collection(Song.not_user_created.free.by_popularity.limit(4))

    @instruments = Instrument.visible
  end

  def download

  end
end
