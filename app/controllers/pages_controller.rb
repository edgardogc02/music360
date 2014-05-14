class PagesController < ApplicationController
  before_action :authorize, except: [:help]

  def home
    @users = UserChallengeDecorator.decorate_collection(User.not_deleted.exclude(current_user.id).limit(4))
    @songs = SongQuickStartDecorator.decorate_collection(Song.free.by_popularity.limit(4))
    
    @instruments = Instrument.visible
  end

  def download

  end
end
