class UserPaidSongsController < ApplicationController
	before_action :authorize

  def buy
    song = Song.friendly.find(params[:id])
    @user_paid_song_form = UserPaidSongForm.new(current_user.user_paid_songs.build(song: song), current_user.payments.build)
  end

  def show
    @user_paid_song = UserPaidSong.friendly.find(params[:id])
  end

  def create
    @user_paid_song_form = UserPaidSongForm.new(current_user.user_paid_songs.build, current_user.payments.build)

    if @user_paid_song_form.save(params[:user_paid_song_form])
      flash[:notice] = "You have successfully bought this song."
      redirect_to @user_paid_song_form.user_paid_song
    else
      flash.now[:warning] = "Something went wrong. Please try again."
      render "buy"
    end
  end

end
