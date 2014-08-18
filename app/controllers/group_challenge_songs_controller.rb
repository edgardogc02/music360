class GroupChallengeSongsController < ApplicationController
	before_action :authorize
  before_action :set_group

  def index
    @songs = SongGroupChallengeDecorator.decorate_collection(Song.free.not_user_created.by_popularity.limit(4))
    render layout: false
  end

  private

  def set_group
    @group = GroupDecorator.decorate(Group.find(params[:group_id]))
  end

end
