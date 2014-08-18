class SongsController < ApplicationController
	before_action :authorize, except: [:show]
	before_action :set_song, only: [:show, :destroy]
#  before_action :authorize_group # TODO

	def index
    if params[:title]
      if display_premium?
        songs = Song.not_user_created.by_title(params[:title])
      else
        songs = Song.free.not_user_created.by_title(params[:title])
      end
      if !params[:group_id].blank?
        @songs = SongGroupChallengeDecorator.decorate_collection(songs)
      else
        @songs = SongDecorator.decorate_collection(songs)
      end
    else
      @songs = ResumedPremiumSongsFactory.new(params, display_premium?).songs_list
      @most_popular_songs = ResumedMostPopularSongsFactory.new(params).songs_list
      @my_songs = ResumedMySongsFactory.new(params, current_user).songs_list
      @new_songs = ResumedNewSongsFactory.new(params).songs_list
    end
	end

	def for_challenge
    @songs = SongChallengeDecorator.decorate_collection(Song.free.not_user_created.by_popularity.limit(4))
    render layout: false
	end

	def list
    @songs = SongsListFactory.new(current_user, params).songs_list
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
