class SongsController < ApplicationController
	before_action :authorize, except: [:show]
	before_action :set_song, only: [:show, :destroy, :activities]
#  before_action :authorize_group # TODO

	def index
    if params[:title]
      @searched_songs = SearchSongsFactory.new(params).songs_list
    else
      @songs = ResumedPremiumSongsFactory.new(params).songs_list
      @most_popular_songs = ResumedMostPopularSongsFactory.new(params).songs_list
      @my_songs = ResumedMySongsFactory.new(params, current_user).songs_list
      @new_songs = ResumedNewSongsFactory.new(params).songs_list
    end
	end

	def for_challenge
    @songs = SongChallengeDecorator.decorate_collection(Song.not_user_created.by_popularity.limit(4))
    render layout: false
	end

	def list
    @songs = SongsListFactory.new(current_user, params).songs_list
  end

	def show
	  @song = SongDecorator.decorate(@song)
	  @more_songs = SongChallengeDecorator.decorate_collection(Song.not_user_created.by_popularity.limit(4))
		@top_scores = @song.top_scores.limit(5)
    @activity_feeds = @song.activities.order('created_at DESC').page(1).per(10)
		@scores = @song.top_scores
		@payment_method = PaymentMethod.credit_card

    if current_user
      @user_purchased_song_form = UserPurchasedSongForm.new(current_user.user_purchased_songs.build(song: @song))
    end

    render layout: "detail"
	end

  def activities
    @activity_feeds = @song.activities.order('created_at DESC').page(params[:page]).per(10)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def free
    @songs = SongDecorator.decorate_collection(Song.by_popularity.page params[:page])
  end

	private

	def set_song
		@song = Song.find(params[:id])
	end
end
