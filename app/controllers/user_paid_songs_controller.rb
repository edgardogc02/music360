class UserPaidSongsController < ApplicationController
	before_action :authorize

  def buy
    song = Song.friendly.find(params[:id])
    @user_paid_song = current_user.user_paid_songs.build(song: song)
  end

  def show
    @user_paid_song = UserPaidSong.friendly.find(params[:id])
  end

  def create
    @user_paid_song = current_user.user_paid_songs.build(user_paid_song_params)

    if @user_paid_song.save
      flash[:notice] = "You have successfully bought this song."
      redirect_to @user_paid_song
    else
      flash.now[:warning] = "Something went wrong. Please try again."
      render "buy"
    end
  end

  private

  def user_paid_song_params
    params.require(:user_paid_song).permit(:song_id)
  end

end
