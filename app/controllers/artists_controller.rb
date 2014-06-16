class ArtistsController < ApplicationController
	before_action :authorize, except: [:create]
	before_action :set_artist, only: [:show, :edit, :update, :destroy]

	def index
		@artists = ArtistDecorator.decorate_collection(Artist.all.limit(12))
		@top_artists = Echowrap.artist_top_hottt(results: 12, bucket: ['hotttnesss', 'images'])
	end

	def show
	  @artist = ArtistDecorator.decorate(@artist)
	  if @artist.songs
	    @songs = SongDecorator.decorate_collection(@artist.songs.limit(4))    
      @challenges = ChallengeDecorator.decorate_collection(Challenge.where("song_id IN (?)", @artist.songs.pluck(:id)).finished.limit(4))
    end
    
    #@node = Musicnodes.new("createalbumnode", "U2").get_album_node.parsed_response
	end

  def most_popular
    @artists = Echowrap.artist_top_hottt(results: 50, bucket: ['hotttnesss', 'images'])
  end
  
  def top_list
    @artists = Artist.all.page params[:page]
  end

	private

	def set_artist
	  @artist = Artist.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    @artist = EchonestArtist.new(params[:id])
	end

	def artist_params
	  params.require(:artist).permit(:title)
	end
end
