class SongsController < ApplicationController
	before_action :authorize
	before_action :set_song, only: [:show, :edit, :update, :destroy]

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

  def edit
  end

  def update
    if @song.update_attributes(song_params)
      redirect_to song_path(@song)
    else
      render "edit"
    end
  end

  def free
    @songs = SongDecorator.decorate_collection(Song.free.by_popularity.page params[:page])
  end

	private

  def song_params
    params.require(:song).permit(:title, :writer, :length, :difficulty, :arranger_userid, :comment, :status, :onclient, :published_at, :cover, :user_created)
  end

	def set_song
		@song = Song.friendly.find(params[:id])
	end
end
