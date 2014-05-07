class PagesController < ApplicationController
  before_action :authorize

  def home
    @song = Song.first.decorate
    @regular_users = User.not_deleted.exclude(current_user.id).limit(4)
    @songs = SongDecorator.decorate_collection(Song.free.by_popularity.limit(4))
  end

  def download

  end
end
