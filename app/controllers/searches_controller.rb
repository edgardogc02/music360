class SearchesController < ApplicationController

	before_action :authorize

  def show
    @my_friends = UserDecorator.decorate_collection(current_user.facebook_friends.by_username_or_email(params[:id]).limit(6))
    @users = UserDecorator.decorate_collection(User.by_username_or_email(params[:id]).excludes(current_user.user_facebook_friends.friends_ids).exclude(current_user.id).limit(6))
    @artists = ArtistDecorator.decorate_collection(Artist.by_title(params[:id]).limit(6))
    @songs = SongDecorator.decorate_collection(Song.by_title(params[:id]).limit(6))
    @challenges = Challenge.by_challenger_username_or_email(params[:id]).limit(4)
    if @challenges.size < 4
      @challenges += Challenge.by_challenged_username_or_email(params[:id]).excludes(@challenges.map{|id| id}).limit(4 - @challenges.size)
    end
    if @challenges.size < 4
      @challenges += Challenge.by_song_title(params[:id]).excludes(@challenges.map{|id| id}).limit(4 - @challenges.size)
    end
    @challenges = ChallengeDecorator.decorate_collection(@challenges)
  end

  def users
    @users = UserDecorator.decorate_collection(User.by_username_or_email(params[:id]).excludes(current_user.user_facebook_friends.friends_ids).exclude(current_user.id))
  end

  def my_friends
    @my_friends = UserDecorator.decorate_collection(current_user.facebook_friends.by_username_or_email(params[:id]))
  end

  def artists
    @artists = ArtistDecorator.decorate_collection(Artist.by_title(params[:id]))
  end

  def songs
    @songs = SongDecorator.decorate_collection(Song.by_title(params[:id]))
  end

  def create
    if !params[:search].blank? and !params[:search][:value].blank?
      redirect_to search_path(params[:search][:value])
    else
      flash[:warning] = "No value to search"
      redirect_to root_path
    end
  end

end
