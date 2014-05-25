class PagesController < ApplicationController
  before_action :authorize, except: [:help]

  def home
    users = User.not_deleted.exclude(current_user).search_user_relationships(current_user)
    if users.count < 4
      users = User.not_deleted.exclude(current_user.id)
    end
    @users = UserChallengeDecorator.decorate_collection(users.limit(4))
    @songs = SongQuickStartDecorator.decorate_collection(Song.free.by_popularity.limit(4))
    
    @instruments = Instrument.visible
  end

  def download

  end
end
