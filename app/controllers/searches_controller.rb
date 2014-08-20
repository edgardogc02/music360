class SearchesController < ApplicationController

	before_action :authorize

  def show
    @my_friends = UserDecorator.decorate_collection(current_user.facebook_friends.by_username_or_email(params[:id]).limit(6))
    @users = UserDecorator.decorate_collection(User.by_username_or_email(params[:id]).excludes(current_user.user_facebook_friends.friends_ids).exclude(current_user.id).limit(6))
    @artists = ArtistDecorator.decorate_collection(Artist.by_title(params[:id]).limit(6))
    songs = Song.by_title(params[:id]).limit(6)
    if params[:group_id]
      @songs = SongGroupChallengeDecorator.decorate_collection(songs)
    else
      @songs = SongDecorator.decorate_collection(songs)
    end
    @groups = GroupDecorator.decorate_collection(Group.searchable.by_name(params[:id]).limit(6))
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
    songs = Song.by_title(params[:id])
    if params[:group_id]
      @songs = SongGroupChallengeDecorator.decorate_collection(songs)
    else
      @songs = SongDecorator.decorate_collection(songs)
    end
  end

  def groups
    @groups = GroupDecorator.decorate_collection(Group.searchable.by_name(params[:id]))
  end

  def create
    if !params[:search].blank? and !params[:search][:value].blank?
      redirect_to search_path(params[:search][:value], group_id: params[:search][:group_id])
    else
      flash[:warning] = "No value to search"
      redirect_to root_path
    end
  end

end
