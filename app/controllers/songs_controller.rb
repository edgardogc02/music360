class SongsController < ApplicationController
	before_action :authorize
	before_action :set_song, only: [:show, :edit, :update, :destroy]

	def index
		unless params[:category].present?
			@categories = Category.all
		else
			@songs = Song.where(category_id: params[:category])
		end
	end

	def show

	end

  def free
    @songs = Song.free.by_popularity.page params[:page]
  end

	private

	def set_song
		@song = Song.friendly.find(params[:id])
	end
end
