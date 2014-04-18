class SongsController < ApplicationController
	before_action :authorize
	before_action :set_song, only: [:show, :edit, :update, :destroy]

	def index
	  @songs = Song.free.by_popularity.page params[:page]
#		unless params[:category].present?
#			@categories = Category.all
#		else
#			@songs = Song.where(category_id: params[:category])
#		end
	end

	def show
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
    @songs = Song.free.by_popularity.page params[:page]
  end

	private

  def song_params
    params.require(:song).permit(:title, :writer, :length, :difficulty, :arranger_userid, :comment, :status, :onclient, :published_at, :cover)
  end

	def set_song
		@song = Song.friendly.find(params[:id])
	end
end
