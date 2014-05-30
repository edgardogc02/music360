class SongsController < ApplicationController
	before_action :authorize
	before_action :set_song, only: [:show, :edit, :update, :destroy]

	def index
	  if params[:title]
      @songs = SongDecorator.decorate_collection(Song.visible.by_title(params[:title]).page params[:page])
    else
      @songs = SongDecorator.decorate_collection(Song.visible.free.by_popularity.page params[:page])
    end
	end

	def for_challenge
    @songs = SongChallengeDecorator.decorate_collection(Song.free.by_popularity.limit(12))
    render layout: false
	end

	def show
	  @song = SongDecorator.decorate(@song)
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
    params.require(:song).permit(:title, :writer, :length, :difficulty, :arranger_userid, :comment, :status, :onclient, :published_at, :cover, :visible)
  end

	def set_song
		@song = Song.friendly.find(params[:id])
	end
end
