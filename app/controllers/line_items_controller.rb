class LineItemsController < ApplicationController

  before_action :authorize, except: [:show]

  def create
    song = Song.find(params[:song_id])
    cart = current_user.current_cart
    line_item = cart.add_song(song.id)

    respond_to do |format|
      if line_item.save
        format.html { redirect_to line_item.cart, notice: "The song was added to your cart" }
      else
        format.html do
          flash[:warning] = "Something went wrong. Please try again"
          redirect_to songs_path
        end
      end
    end
  end

  def destroy
    line_item = LineItem.find(params[:id])
    line_item.destroy
    redirect_to current_user.current_cart, notice: "The song was successfully removed from your cart"
  end

end
