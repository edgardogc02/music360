class SongsController < ApplicationController
	before_action :authorize, except: [:show]
	before_action :set_song, only: [:show, :destroy]

	def index
    if params[:title]
      if display_premium?
        songs = Song.not_user_created
      else
        songs = Song.free.not_user_created
      end
      @songs = SongDecorator.decorate_collection(songs.by_title(params[:title]))
    else
      if display_premium?
        @songs = SongDecorator.decorate_collection(Song.paid.by_popularity.limit(5))
      else
        @songs = SongDecorator.decorate_collection(Song.free.not_user_created.by_popularity.limit(5))
      end
      @most_popular_songs = ResumedMostPopularSongsList.new
      @my_songs = ResumedMySongsList.new(current_user)
      @new_songs = ResumedNewSongsList.new
    end
	end

	def for_challenge
    @songs = SongChallengeDecorator.decorate_collection(Song.free.not_user_created.by_popularity.limit(4))
    render layout: false
	end

	def list
    @songs = SongsListFactory.new(params[:view], current_user, params[:page]).songs_list
  end

	def show
	  @song = SongDecorator.decorate(@song)
	  @more_songs = SongChallengeDecorator.decorate_collection(Song.free.not_user_created.by_popularity.limit(4))

    @scores = @song.top_scores.limit(5)
	end

  def free
    @songs = SongDecorator.decorate_collection(Song.free.by_popularity.page params[:page])
  end

	private

	def set_song
		@song = Song.find(params[:id])
	end
end
