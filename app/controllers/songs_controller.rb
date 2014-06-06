class SongsController < ApplicationController
	before_action :authorize
	before_action :set_song, only: [:show, :destroy]

	def index
	  if params[:title]
      @songs = SongDecorator.decorate_collection(Song.free.not_user_created.by_title(params[:title]).page params[:page])
    else
      @songs = SongDecorator.decorate_collection(Song.free.not_user_created.by_popularity.page params[:page])
    end
	end

	def for_challenge
    @songs = SongChallengeDecorator.decorate_collection(Song.free.not_user_created.by_popularity.limit(12))
    render layout: false
	end

	def show
	  @song = SongDecorator.decorate(@song)
	  @more_songs = SongChallengeDecorator.decorate_collection(Song.free.not_user_created.by_popularity.limit(4))
	  users = User.not_deleted.exclude(current_user).search_user_relationships(current_user).limit(4) | User.not_deleted.exclude(current_user).limit(4)
    @users = UserChallengeDecorator.decorate_collection(users.take(4))
	end

  def free
    @songs = SongDecorator.decorate_collection(Song.free.by_popularity.page params[:page])
  end

	private

	def set_song
		@song = Song.find(params[:id])
	end
end
