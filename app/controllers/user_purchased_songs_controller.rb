class UserPurchasedSongsController < ApplicationController
	before_action :authorize

  def buy
    song = Song.find(params[:id])
    @user_purchased_song_form = UserPurchasedSongForm.new(current_user.user_purchased_songs.build(song: song))
  end

  def show
    @user_purchased_song = UserPurchasedSong.find(params[:id])
  end

  def create
    @user_purchased_song_form = UserPurchasedSongForm.new(current_user.user_purchased_songs.build)

    if @user_purchased_song_form.save(user_purchased_song_form_params)
      flash[:notice] = "You have successfully purchased this song."
      redirect_to @user_purchased_song_form.user_purchased_song
    else
      flash.now[:warning] = "Something went wrong. Please try again."
      render "buy"
    end
  end

  private

  def user_purchased_song_form_params
    params.require(:user_purchased_song_form).permit(:song_id, :amount, :payment_method_id, :paymill_token, :currency)
  end

end
