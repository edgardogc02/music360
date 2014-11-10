class ArtistsController < ApplicationController
	before_action :authorize, except: [:create, :show]
	before_action :redirect_to_current_if_not_signed_in, only: [:show]
	before_action :set_artist, only: [:show, :edit, :update, :destroy, :activities]

	def index
		@artists = ArtistDecorator.decorate_collection(Artist.not_top.limit(12))
		@top_artists = ArtistDecorator.decorate_collection(Artist.top.limit(12))
	end

	def show
	  @artist = ArtistDecorator.decorate(@artist)
	  if @artist.songs
	    @songs = SongDecorator.decorate_collection(@artist.songs.limit(4))
      @challenges = ChallengeDecorator.decorate_collection(Challenge.where("song_id IN (?)", @artist.songs.pluck(:id)).finished.limit(4))
    end

    #@node = Musicnodes.new("createalbumnode", "U2").get_album_node.parsed_response

    @activity_feeds = PublicActivity::Activity.where(id: @artist.songs.map{ |s| s.activities}.flatten).order('created_at DESC').page(1).per(10)

    render layout: "detail"
	end

  def most_popular
    @artists = Echowrap.artist_top_hottt(results: 50, bucket: ['hotttnesss', 'images'])
  end

  def top_list
    @artists = Artist.all.page params[:page]
  end

  def activities
    @activity_feeds = PublicActivity::Activity.where(id: @artist.songs.map{ |s| s.activities}.flatten).order('created_at DESC').page(params[:page]).per(10)
    respond_to do |format|
      format.html
      format.js
    end
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
