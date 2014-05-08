class PagesController < ApplicationController
  before_action :authorize

  def home
    @users = UserChallengeDecorator.decorate_collection(User.not_deleted.exclude(current_user.id).limit(4))
    @songs = SongQuickStartDecorator.decorate_collection(Song.free.by_popularity.limit(4))
  end

  def download

  end
end
