class ArtistsController < ApplicationController
	before_action :authorize, except: [:create]
	before_action :set_artist, only: [:show, :edit, :update, :destroy]

	def index
		@artists = Artist.all.page params[:page]
	end

	def show
	  @songs = SongDecorator.decorate_collection(@artist.songs.limit(4))    
    users = User.not_deleted.exclude(current_user).search_user_relationships(current_user).limit(4) | User.not_deleted.exclude(current_user).limit(4)
    @users = UserChallengeDecorator.decorate_collection(users.take(4))    
    @challenges = ChallengeDecorator.decorate_collection(Challenge.where("song_id IN (?)", @artist.songs.pluck(:id)).finished.limit(4))
   
    @more_songs = SongChallengeDecorator.decorate_collection(Song.free.not_user_created.by_popularity.limit(4))
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
	end

	def artist_params
	  params.require(:artist).permit(:title)
	end
end
