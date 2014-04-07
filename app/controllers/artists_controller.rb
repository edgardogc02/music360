class ArtistsController < ApplicationController
	before_action :authorize, except: [:create]
	before_action :set_artist, only: [:show, :edit, :update, :destroy]

	def index
		@artists = Artist.all
	end

	def show
	end

  def most_popular
    @artists = Echowrap.artist_top_hottt(results: 50, bucket: ['hotttnesss', 'images'])
  end

	private

	def set_artist
		@artist = Artist.friendly.find(params[:id])
	end

	def artist_params
	  params.require(:artist).permit(:title)
	end
end
